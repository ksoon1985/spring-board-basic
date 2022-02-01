# spring-board-basic

기존 jsp 게시판 프로젝트 -> spring 게시판 프로젝트로 


## structure 
* src.main.java.kr.or.ksh
  * board 
    * dao - BoardDAO
    * dto - BoardDTO, PageDTO
    * mapper - boardMapper.xml
    * service - BoardListService, BoardWriteService
      * impl - BoardListServiceImpl, BoardWriteServiceImpl
    * web - BoardController
  * common - ServletUpload

* src.main.resources
  * log4j.xml
  * mybatis-config.xml : mybatis에 쓰일 parameter alias

* src.main.webapp
  * config - config.properties : db 실제 정보들
  * resources - css,images,js
  * WEB-INF
    * spring
      * root-context.xml 
      * appServlet - servlet-context.xml 
    * views - jsp
    * web.xml 
    

## setting 
* pom.xml
* web.xml
* servlet-context.xml
* root-context.xml (+ config.properties)
* log4j.xml
* mybatis-config.xml

### pom.xml 
maven project의 핵심 파일  
프로젝트에 필요한 라이브러리 관리  
```xml
기본 셋팅에서 추가된 부분

<!--추가 oracle repository setting start-->
<repositories>
  <repository>
    <id>oracle</id>
    <url>http://maven.jahia.org/maven2</url>         
  </repository>	
</repositories>
<!-- oracle repository setting end-->
  
<!--추가 log4jdbc-remix(query를 log찍고 싶을때)  -->
<dependency>
  <groupId>org.lazyluke</groupId>
  <artifactId>log4jdbc-remix</artifactId>
  <version>0.2.7</version>
</dependency>
<!-- log4j2/log4jdbc-log4j2-jdbc4.1 -->
<dependency>
  <groupId>org.bgee.log4jdbc-log4j2</groupId>
  <artifactId>log4jdbc-log4j2-jdbc4.1</artifactId>
  <version>1.16</version>
</dependency>
    
<!--추가 jdbc -->
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-jdbc</artifactId>
  <version>${org.springframework-version}</version>
</dependency>
<dependency>
  <groupId>com.oracle</groupId>
  <artifactId>ojdbc6</artifactId>
  <version>12.1.0.2</version>
</dependency>
<!--추가 connection pool -->
<dependency>
  <groupId>commons-dbcp</groupId>
  <artifactId>commons-dbcp</artifactId>
  <version>1.4</version>
</dependency>
<!--추가 Mybatis -->
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>3.4.1</version>
</dependency>
<!--추가 Spring connect Mybatis -->
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis-spring</artifactId>
  <version>1.3.0</version>
</dependency>

<!--추가 by upload start -->
<dependency>
  <groupId>commons-fileupload</groupId>
  <artifactId>commons-fileupload</artifactId>
  <version>1.4</version>
</dependency>
<dependency>
  <groupId>commons-io</groupId>
  <artifactId>commons-io</artifactId>
  <version>2.7</version>
</dependency>
<!-- by upload end -->
		
<!--추가 by subneil start-->
<dependency>
  <groupId>servlets.com</groupId>
  <artifactId>cos</artifactId>
  <version>05Nov2002</version>
</dependency>
<!-- by subneil end-->

```

### web.xml
최초로 WAS 구동시, 각종 설정을 정의  
```xml
추가된 부분만
<!--추가  encoding Filter -->
<filter>
  <filter-name>encodingFilter</filter-name>
  <filter-class>
    org.springframework.web.filter.CharacterEncodingFilter
  </filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
  <init-param>
    <param-name>forceEncoding</param-name>
    <param-value>true</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>encodingFilter</filter-name>
  <url-pattern>*.sp</url-pattern>
</filter-mapping>
```

### servlet-context.xml
요청과 관련된 객체 정의  
url과 관련된 controller, @(어노테이션), ViewResolver, Interceptor, MultipartResolver등 설정 

### root-context.xml
servlet-context와 반대로 view와 관련되지 않은 객체 정의  
Service, Repository(DAO), DB등 비즈니스 로직과 관련된 설정
```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:context="http://www.springframework.org/schema/context" 
  xsi:schemaLocation="http://www.springframework.org/schema/beans https://www.springframework.org/schema/beans/spring-beans.xsd  
    http://www.springframework.org/schema/context  
    http://www.springframework.org/schema/context/spring-context-4.3.xsd">
	
<!-- Root Context: defines shared resources visible to all other web components -->
	
<!--추가 config파일 자동 로드 location="classpath:database.properties" -->
<context:property-placeholder location="/config/*.properties" /> 
	
<!--추가 db connection info. -->
<bean id="dataSourceOR" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
  <property name="driverClassName" value="${spring.dataSourceOR.driverClassName}"/> 
  <property name="url" value="${spring.dataSourceOR.url}"/>
  <property name="username" value="${spring.dataSourceOR.username}"/>   
  <property name="password" value="${spring.dataSourceOR.password}"/>
</bean>
<bean id="dataSource" class="net.sf.log4jdbc.Log4jdbcProxyDataSource">
  <constructor-arg ref="dataSourceOR"/>
  <property name="logFormatter">
    <bean class="net.sf.log4jdbc.tools.Log4JdbcCustomFormatter">
      <property name="loggingType" value="MULTI_LINE"/> 
      <property name="sqlPrefix" value="[SQL]: "/>
    </bean>
  </property>
</bean>
	
<!--추가 1.mybatis f/w db connect  2. sql file location setting-->
<!-- mybatis-config.xml /WEB-INF/spring 에서 src/main/resources로 이동(알수없는 오류때문에 ) -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean" lazy-init="true">
  <property name="dataSource" ref="dataSource" />
  <property name="configLocation" value="classpath:mybatis-config.xml"/>
  <property name="mapperLocations" value="classpath*:**/mapper/*Mapper.xml" />
</bean>
<bean id="sqlsession" class="org.mybatis.spring.SqlSessionTemplate">
  <constructor-arg ref="sqlSessionFactory"/>
</bean>
  	
  	
<!--추가 MultipartResolver setting --> 
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver"> 
	<property name="maxUploadSize" value="100000000" /> 
	<property name="maxInMemorySize" value="100000000" /> 
</bean> 
	
</beans>
```

### config.properties
root-context.xml에 db정보가 있기 때문에 git에 올리기 위해  
db정보는 config.properties에 저장 
```
spring.dataSourceOR.driverClassName= db.driver
spring.dataSourceOR.url= db.url
spring.dataSourceOR.username= db.user
spring.dataSourceOR.password= db.password
```

### log4j.xml
log 관련 설정

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration PUBLIC "-//APACHE//DTD LOG4J 1.2//EN" "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">

<!-- Appenders -->
<appender name="console" class="org.apache.log4j.ConsoleAppender">
  <param name="Target" value="System.out" />
  <layout class="org.apache.log4j.PatternLayout">
    <!-- <param name="ConversionPattern" value="%-5p: %c - %m%n" /> -->
    <param name="ConversionPattern" value="[%d{yy-MM-dd HH:mm:ss}][%F][%L][%M][%p] %m %n" />	
  </layout>
</appender>
	
<!--추가 by file out  -->
<!-- 	<appender name="dailyout" class="org.apache.log4j.DailyRollingFileAppender">
  <param name="file" value="C:/study/workspace/dailyLog/dailyout.log"/>
  <param name="Append" value="true"/>
  <param name="encoding" value="utf-8"/>
  <param name="DatePattern" value="yyyyMMdd'.'"/>
  <layout class="org.apache.log4j.PatternLayout">
    <param name="ConversionPattern" value="[%d{yy-MM-dd HH:mm:ss}][%F][%L][%M][%p] %m %n"/>
  </layout>
</appender> -->
<!-- by file out  end-->
	
<!-- Application Loggers -->
<logger name="kr.or.ksh">
	<level value="info" />
</logger>
	
<!-- 3rdparty Loggers -->
<logger name="org.springframework.core">
	<level value="info" />
</logger>
	
<logger name="org.springframework.beans">
	<level value="info" />
</logger>
	
<logger name="org.springframework.context">
	<level value="info" />
</logger>

<logger name="org.springframework.web">
	<level value="info" />
</logger>
	
<!--추가  -->
<!-- 	<logger name="jdbc.audit" additivity="false">
  <level value="trace" />
  <appender-ref ref="console" />
  <appender-ref ref="dailyout"/>
</logger>
	
<logger name="jdbc.sqltiming" additivity="false">
  <level value="trace" />
  <appender-ref ref="console" /> 
  <appender-ref ref="dailyout"/>
</logger> -->
	

<!-- Root Logger -->
<root>
  <priority value="warn" />
  <appender-ref ref="console" />
  <!--추가  -->
  <!-- <appender-ref ref="dailyout" /> -->
</root>
	
</log4j:configuration>
```

### mybatis-config.xml 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "HTTP://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
	<settings>
		<setting name="cacheEnabled" value="false" />
		<setting name="useGeneratedKeys" value="true" />
		<setting name="defaultExecutorType" value="REUSE" />
	</settings>
	<!-- aliaes -->
    <typeAliases>
         <typeAlias alias="hashMap" type="java.util.HashMap" />
         <typeAlias alias="map" type="java.util.Map" />
		 <typeAlias alias="bdto" type="kr.or.ksh.board.dto.BoardDTO" />
         <typeAlias alias="pdto" type="kr.or.ksh.board.dto.PageDTO" />
    </typeAliases>	
</configuration>

```

## repository
window > preference > maven > user setting  
셋팅후 maven > update project 하면 library들 해당 폴더에 다운됨  

### repo-setting.xml
```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
	<localRepository>C:\Users\kwons\.m2\spring-board-basic-repository</localRepository>
	<interactiveMode>true</interactiveMode>
	<offline>false</offline>
</settings>
```


