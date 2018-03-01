package com.spring.mybatis.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.executor.parameter.DefaultParameterHandler;
import org.apache.ibatis.executor.parameter.ParameterHandler;
import org.apache.ibatis.executor.statement.RoutingStatementHandler;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
@Intercepts({
    @Signature(method = "query", type = Executor.class, args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class }),
    @Signature(method = "prepare", type = StatementHandler.class, args = {Connection.class }) 
    })
public class MybatisPageInterceptor implements Interceptor{
	
	private static final Logger log = Logger.getLogger(MybatisPageInterceptor.class); 

    public static final String MYSQL = "mysql";  
    public static final String ORACLE = "oracle";  
  
    protected String databaseType;// 数据库类型，不同的数据库有不同的分页方法  
  
    @SuppressWarnings("rawtypes")  
    protected ThreadLocal<Page> pageThreadLocal = new ThreadLocal<Page>();  
  
    public String getDatabaseType() {  
        return databaseType;  
    }  
  
    public void setDatabaseType(String databaseType) {  
        if (!databaseType.equalsIgnoreCase(MYSQL) && !databaseType.equalsIgnoreCase(ORACLE)) {  
            throw new PageNotSupportException("Page not support for the type of database, database type [" + databaseType + "]");  
        }  
        this.databaseType = databaseType;  
    }  
    
	@Override
	public Object intercept(Invocation invocation) throws Throwable {  
        if (invocation.getTarget() instanceof StatementHandler) { // 控制SQL和查询总数的地方  
            Page page = pageThreadLocal.get();  
            if (page == null) { //不是分页查询  
                return invocation.proceed();  
            }  
  
            RoutingStatementHandler handler = (RoutingStatementHandler) invocation.getTarget();  
            StatementHandler delegate = (StatementHandler) ReflectUtil.getFieldValue(handler, "delegate");  
            BoundSql boundSql = delegate.getBoundSql();  
              
            Connection connection = (Connection) invocation.getArgs()[0];  
            checkDatabaseType(connection); // 检查数据库类型  
  
            if (page.getTotalPage() > -1) {  
                if (log.isTraceEnabled()) {  
                    log.trace("已经设置了总页数, 不需要再查询总数.");  
                }  
            } else {  
                Object parameterObj = boundSql.getParameterObject();  
                MappedStatement mappedStatement = (MappedStatement) ReflectUtil.getFieldValue(delegate, "mappedStatement");  
                queryTotalRecord(page, parameterObj, mappedStatement, connection);  
            }  
  
            String sql = boundSql.getSql();  
            String pageSql = buildPageSql(page, sql);  
            if (log.isDebugEnabled()) {  
                log.debug("分页时, 生成分页pageSql: " + pageSql);  
            }  
            ReflectUtil.setFieldValue(boundSql, "sql", pageSql);  
  
            return invocation.proceed();  
        } else { // 查询结果的地方  
            // 获取是否有分页Page对象  
            Page<?> page = findPageObject(invocation.getArgs()[1]);  
            if (page == null) {  
                if (log.isTraceEnabled()) {  
                    log.trace("没有Page对象作为参数, 不是分页查询.");  
                }  
                return invocation.proceed();  
            } else {  
                if (log.isTraceEnabled()) {  
                    log.trace("检测到分页Page对象, 使用分页查询.");  
                }
            }  
            //设置真正的parameterObj  
            invocation.getArgs()[1] = extractRealParameterObject(invocation.getArgs()[1]);  
  
            pageThreadLocal.set(page);  
            try {  
                Object resultObj = invocation.proceed(); // Executor.query(..)  
                if (resultObj instanceof List) {  
                    page.setResults((List) resultObj);  
                }  
                return resultObj;  
            } finally {  
                pageThreadLocal.remove();  
            }  
        }  
	}

	@Override
	public Object plugin(Object arg0) {
        return Plugin.wrap(arg0, this); 
	}

	@Override
	public void setProperties(Properties arg0) {
        String databaseType = arg0.getProperty("databaseType");  
        if (databaseType != null) {  
            setDatabaseType(databaseType);  
        }  
	}

    protected Page<?> findPageObject(Object parameterObj) {  
        if (parameterObj instanceof Page<?>) {  
            return (Page<?>) parameterObj;  
        } else if (parameterObj instanceof Map) {  
            for (Object val : ((Map<?, ?>) parameterObj).values()) {  
                if (val instanceof Page<?>) {  
                    return (Page<?>) val;  
                }  
            }  
        }  
        return null;  
    }  
    /** 
     * 把真正的参数对象解析出来 
     * Spring会自动封装对个参数对象为Map<String, Object>对象 
     * 对于通过@Param指定key值参数我们不做处理，因为XML文件需要该KEY值 
     * 而对于没有@Param指定时，Spring会使用0,1作为主键 
     * 对于没有@Param指定名称的参数,一般XML文件会直接对真正的参数对象解析， 
     * 此时解析出真正的参数作为根对象 
     */  
    protected Object extractRealParameterObject(Object parameterObj) {  
        if (parameterObj instanceof Map<?, ?>) {  
            Map<?, ?> parameterMap = (Map<?, ?>) parameterObj;  
            if (parameterMap.size() == 2) {  
                boolean springMapWithNoParamName = true;  
                for (Object key : parameterMap.keySet()) {  
                    if (!(key instanceof String)) {  
                        springMapWithNoParamName = false;  
                        break;  
                    }  
                    String keyStr = (String) key;  
                    if (!"0".equals(keyStr) && !"1".equals(keyStr)) {  
                        springMapWithNoParamName = false;  
                        break;  
                    }  
                }  
                if (springMapWithNoParamName) {  
                    for (Object value : parameterMap.values()) {  
                        if (!(value instanceof Page<?>)) {  
                            return value;  
                        }  
                    }  
                }  
            }  
        }  
        return parameterObj;  
    }  
    
    /**
     * 检查数据库类型
     */
    protected void checkDatabaseType(Connection connection) throws SQLException {  
        if (databaseType == null) {  
            String productName = connection.getMetaData().getDatabaseProductName();  
            if (log.isTraceEnabled()) {  
                log.trace("Database productName: " + productName);  
            }
            productName = productName.toLowerCase();  
            if (productName.indexOf(MYSQL) != -1) {  
                databaseType = MYSQL;  
            } else if (productName.indexOf(ORACLE) != -1) {  
                databaseType = ORACLE;  
            } else {  
                throw new PageNotSupportException("Page not support for the type of database, database product name [" + productName + "]");  
            }  
            if (log.isInfoEnabled()) {  
                log.info("自动检测到的数据库类型为: " + databaseType);  
            }
        }  
    }  
    
    /** 
     * 生成分页SQL 
     */  
    protected String buildPageSql(Page<?> page, String sql) {  
        if (MYSQL.equalsIgnoreCase(databaseType)) {  
            return buildMysqlPageSql(page, sql);  
        } else if (ORACLE.equalsIgnoreCase(databaseType)) {  
            return buildOraclePageSql(page, sql);  
        }  
        return sql;  
    } 
    
    /** 
     * 生成Mysql分页查询SQL 
     */  
    protected String buildMysqlPageSql(Page<?> page, String sql) {  
        // 计算第一条记录的位置，Mysql中记录的位置是从0开始的。  
        int offset = (page.getPageNo() - 1) * page.getPageSize();  
        return new StringBuilder(sql).append(" limit ").append(offset).append(",").append(page.getPageSize()).toString();  
    }  
    
    /** 
     * 生成Oracle分页查询SQL 
     */  
    protected String buildOraclePageSql(Page<?> page, String sql) {  
        // 计算第一条记录的位置，Oracle分页是通过rownum进行的，而rownum是从1开始的  
        int offset = (page.getPageNo() - 1) * page.getPageSize() + 1;  
        StringBuilder sb = new StringBuilder(sql);  
        sb.insert(0, "select u.*, rownum r from (").append(") u where rownum < ").append(offset + page.getPageSize());  
        sb.insert(0, "select * from (").append(") where r >= ").append(offset);  
        return sb.toString();  
    }  
    
    /** 
     * 查询总数 
     */  
    protected void queryTotalRecord(Page<?> page, Object parameterObject, MappedStatement mappedStatement, Connection connection) throws SQLException {  
        BoundSql boundSql = mappedStatement.getBoundSql(page);  
        String sql = boundSql.getSql();  
        String countSql = this.buildCountSql(sql);  
        if (log.isDebugEnabled()) {  
            log.debug("分页时, 生成countSql: " + countSql);  
        }
  
        List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();  
        BoundSql countBoundSql = new BoundSql(mappedStatement.getConfiguration(), countSql, parameterMappings, parameterObject);  
        ParameterHandler parameterHandler = new DefaultParameterHandler(mappedStatement, parameterObject, countBoundSql);  
        PreparedStatement pstmt = null;  
        ResultSet rs = null;  
        try {  
            pstmt = connection.prepareStatement(countSql);  
            parameterHandler.setParameters(pstmt);  
            rs = pstmt.executeQuery();  
            if (rs.next()) {  
                long totalRecord = rs.getLong(1);  
                page.setTotalRecord(totalRecord);  
            }  
        } finally {  
            if (rs != null)  
                try {  
                    rs.close();  
                } catch (Exception e) {  
                    log.warn("关闭ResultSet时异常.", e);  
                }  
            if (pstmt != null)  
                try {  
                    pstmt.close();  
                } catch (Exception e) {  
                    log.warn("关闭PreparedStatement时异常.", e);  
                }  
        }  
    }  
    
    /** 
     * 根据原Sql语句获取对应的查询总记录数的Sql语句 
     */  
    protected String buildCountSql(String sql) {  
        int index = sql.indexOf("from");  
        return "select count(*) " + sql.substring(index);  
    }  

}
