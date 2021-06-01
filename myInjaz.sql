-- MySQL dump 10.13  Distrib 8.0.25, for Linux (x86_64)
--
-- Host: localhost    Database: injaz
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `database_profile`
--


LOCK TABLES `database_profile` WRITE;
/*!40000 ALTER TABLE `database_profile` DISABLE KEYS */;
INSERT INTO `database_profile` VALUES ('userProfile','userProfile','user',1);
/*!40000 ALTER TABLE `database_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `database_query`
--



LOCK TABLES `database_query` WRITE;
/*!40000 ALTER TABLE `database_query` DISABLE KEYS */;
INSERT INTO `database_query` VALUES ('getUserInfo','SELECT * from user where user.userName = :$inputUserName','SELECT'),('getWithSession','SELECT * from user where user.sessionId = :$inputSessionId','SELECT'),('putSessionId','UPDATE `user`.`user` SET `sessionId` = :$sessionID WHERE (`userName` = :$inputUserName)','UPDATE');
/*!40000 ALTER TABLE `database_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `http_server_request`
--


--

LOCK TABLES `http_server_request` WRITE;
/*!40000 ALTER TABLE `http_server_request` DISABLE KEYS */;
INSERT INTO `http_server_request` VALUES ('/injaz/hello','application/json','json','','GENERIC_ERROR','HELLO_WORLD','CONFIDENTIAL'),('/injaz/inquire','application/json','json',NULL,'GENERIC_ERROR','INQUIRE_USER_DATA','CONFIDENTIAL'),('/injaz/login','application/json','json',NULL,'GENERIC_ERROR','USER_AUTH','CONFIDENTIAL');
/*!40000 ALTER TABLE `http_server_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_query`
--



LOCK TABLES `profile_query` WRITE;
/*!40000 ALTER TABLE `profile_query` DISABLE KEYS */;
INSERT INTO `profile_query` VALUES ('getUserInfo','userProfile',1),('getWithSession','userProfile',3),('putSessionId','userProfile',2);
/*!40000 ALTER TABLE `profile_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_flow`
--



--
-- Dumping data for table `service_flow`
--

LOCK TABLES `service_flow` WRITE;
/*!40000 ALTER TABLE `service_flow` DISABLE KEYS */;
INSERT INTO `service_flow` VALUES ('HELLO_WORLD',_binary '<?xml version=\"1.0\"?>\n\n<scxml\n	xmlns=\"http://www.w3.org/2005/07/scxml\" version=\"1.0\"\n	xmlns:injaz=\"http://actions.injaz.edafa.com/injaz\"\n	xmlns:http=\"http://actions.injaz.edafa.com/http\"\n>\n\n	<datamodel>\n		<data id=\"mobileNum\" expr=\"null\"/>\n		<data id=\"stateName\" expr=\"null\"/>\n		<data id=\"flowStartTime\" expr=\"null\"/>\n	</datamodel>\n\n	<state id=\"IDLE\">\n\n		<transition event=\"HttpRequest.POST\">\n			<assign location=\"stateName\" expr=\"\'IDLE\'\"/>\n			<assign location=\"flowStartTime\" expr=\'new (\"java.util.Date\").getTime()\'/>\n\n			<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' | event=\' + _event.name + \', Request, requestParameters=\' + _event.data\" marker=\"\'CONFIDENTIAL\'\"/>\n\n			<assign location=\"mobileNum\" expr=\"_event.data.get(\'mobileNum\')\"/>\n\n			<raise event=\"internal.idle.parametersStored\"/>\n		</transition>\n\n		<transition event=\"internal.idle.parametersStored\" target=\"FINAL\"/>\n\n	</state>\n\n	<state id=\"FINAL\">\n\n		<onentry>\n			<assign location=\"stateName\" expr=\"\'FINAL\'\"/>\n\n			<http:Respond profileID=\"\'JSON_RESPONSE\'\">\n				<ResponseParams>\n					<ResponseParam name=\"responseId\" value=\"\'hello this is data of this mobileNum \'+mobileNum\"/>\n				</ResponseParams>\n			</http:Respond>\n\n			<assign location=\"flowEndTime\" expr=\'new (\"java.util.Date\").getTime()\'/>\n			<assign location=\"flowDurationTime\" expr=\"flowEndTime - flowStartTime\"/>\n\n		</onentry>\n\n	</state>\n\n</scxml>\n',1,'first fsm','com.edafa.pgw.flow.hello_world',5,1,10,7),('INQUIRE_USER_DATA',_binary '<?xml version=\"1.0\"?>\n<scxml\n	xmlns=\"http://www.w3.org/2005/07/scxml\" version=\"1.0\"\n	xmlns:injaz=\"http://actions.injaz.edafa.com/injaz\"\n	xmlns:http=\"http://actions.injaz.edafa.com/http\"\n	xmlns:db=\"http://actions.injaz.edafa.com/db\"\n	xmlns:kpi=\"http://actions.injaz.edafa.com/kpi\"\n>\n\n\n	<datamodel>\n\n		<!-- Request Parameters -->\n		<data id=\"mobileNum\" expr=\"null\"/>\n		<data id=\"sessionId\" expr=\"null\"/>\n		<data id=\"status\" expr=\"\'FAIL\'\"/>\n		<data id=\"requestCounter\" expr=\"0\"/>\n		<!-- log Parameters -->\n		<data id=\"stateName\" expr=\"null\"/>\n		\n		<!-- number format params -->\n		<data id=\"formattedNumber\" expr=\"null\"/>\n\n		<!-- db parameters -->\n		<data id=\"profileID\" expr=\"null\"/>\n		<data id=\"queryId\" expr=\"null\"/>\n		<data id=\"queryId2\" expr=\"null\"/>\n		<data id=\"dbResponse\" expr=\"null\"/>\n		<data id=\"dbResult\" expr=\"null\"/>\n		<!-- http parameters -->\n		<data id=\"url\" expr=\"null\"/>\n		<data id=\"httpResponse\" expr=\"null\"/>\n		<data id=\"httpResult\" expr=\"\'Not Found\'\"/>\n		\n		<!--kpis-->\n		<data id=\"kpiContext\" expr=\"\'login.serviceflows\'\"/>\n		<data id=\"kpiSetSystem\" expr=\"\'system_counters\'\"/>\n\n	</datamodel>\n\n				<!-- <injaz:Format msisdn=\"\'+201005122113\'\" msisdnFormat=\"\'NATIONAL_KEY\'\" formatLandLine=\"false\" formatWildCard=\"false\" formatShortNumbers=\"false\" response=\"formattedMsisdn\"/> -->\n\n\n	<state id=\"IDLE\">\n\n		<transition event=\"HttpRequest.POST\">\n			<assign location=\"stateName\" expr=\"\'IDLE\'\"/>\n			<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' | event=\' + _event.name + \', Request, requestParameters=\' + _event.data\" marker=\"\'CONFIDENTIAL\'\"/>\n			\n\n			<if cond=\"_event.data.containsKey(\'sessionId\') and _event.data.containsKey(\'mobileNum\')\">\n				<assign location=\"sessionId\" expr=\"_event.data.get(\'sessionId\')\"/>\n				<assign location=\"mobileNum\" expr=\"_event.data.get(\'mobileNum\')\"/>\n				<raise event=\"internal.idle.parametersStored\"/>\n				<injaz:Log logLevel=\"\'info\'\" message=\"stateName +\' | \'+ sessionId + \' in if condition\'\"/>\n\n\n			<else/>\n				<raise event=\"internal.idle.invalidRequestParameters\"/>\n				<assign location=\"status\" expr=\"\'Invalid request parameters\'\"/>\n				<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' in else condition\'\"/>\n			</if>\n\n\n		</transition>\n\n		<transition event=\"internal.idle.invalidRequestParameters\" target=\"FINAL\"/>\n		<transition event=\"internal.idle.parametersStored\" target=\"CHECK_CRED\"/>\n\n\n\n	</state>\n\n\n\n\n\n	<state id=\"CHECK_CRED\">\n		<onentry>\n			<assign location=\"stateName\" expr=\"\'CHECK_CRED\'\"/>\n			<assign location=\"profileID\" expr=\"\'userProfile\'\"/>\n			<assign location=\"queryId\" expr=\"\'getWithSession\'\"/>\n			<raise event=\"internal.CHECK_CRED.dealWithDb\"/>\n		</onentry>	\n		\n		<transition event=\"internal.CHECK_CRED.dealWithDb\">\n\n			<db:Execute profileID=\"profileID\" response=\"dbResponse\">\n					<QueryParams>\n						<QueryParam name=\"$inputSessionId\" value=\"sessionId\"/>\n					</QueryParams>\n\n					<Queries>\n							<Query id=\"getWithSession\" enable=\"true\"/>\n							<Query id=\"getUserInfo\" enable=\"false\"/>\n							<Query id=\"putSessionId\" enable=\"false\"/>\n\n					</Queries>\n\n			</db:Execute>\n\n 			<assign location=\"dbResult\" expr=\"dbResponse.getResponse().getDbResponse().get(queryId).getResponseObject().getSelectedRows()\"/>\n			<injaz:Log logLevel=\"\'info\'\" message=\"\'dbResponse= \'+dbResult\"/>\n\n			<if cond=\"dbResult.size()>0\">\n				<injaz:Format msisdn=\"mobileNum\"\n							msisdnFormat=\"\'NATIONAL_KEY\'\" formatLandLine=\"false\"\n							formatWildCard=\"false\" formatShortNumbers=\"false\"\n							response=\"formattedNumber\" />\n				<injaz:Log logLevel=\"\'info\'\" message=\"\'Num= \'+formattedNumber\"/>\n\n				<if cond=\"dbResult.get(0).get(\'mobileNum\').equals(formattedNumber)\">\n					<raise event=\"internal.CHECK_CRED.credSuccess\"/>\n					\n				<else/>\n					<assign location=\"status\" expr=\"\'authentication failed\'\" />\n					<raise event=\"internal.CHECK_CRED.credFailed\"/>\n				</if>\n				<raise event=\"internal.CHECK_CRED.dbFininshed\"/>\n				<else/>\n					<assign location=\"status\" expr=\"\'authentication failed\'\" />\n					<raise event=\"internal.CHECK_CRED.credNotFound\"/>\n			</if>\n			\n		\n	</transition>\n			<transition event=\"internal.CHECK_CRED.credNotFound\" target=\"FINAL\"/>\n			<transition event=\"internal.CHECK_CRED.credFailed\" target=\"FINAL\"/>\n			<transition event=\"internal.CHECK_CRED.credSuccess\" target=\"REQUEST_DATA\"/>\n\n	</state>\n\n\n	<state id=\"REQUEST_DATA\">\n\n		<onentry>\n			<assign location=\"stateName\" expr=\"\'REQUEST_DATA\'\"/>\n			<raise event=\"internal.REQUEST_DATA.requestData\"/> \n		</onentry>\n\n		<transition event=\"internal.REQUEST_DATA.requestData\">\n			<http:Request url=\"\'http://localhost:8080/injaz/hello\'\"\n				httpMethod=\"\'POST\'\" requestParsingType=\"\'JSON\'\"\n				responseParsingType=\"\'JSON\'\" connectTimeout=\"100\" readTimeout=\"2000\"\n				response=\"httpResponse\">\n				<RequestParams>\n				<RequestParam name=\"mobileNum\"\n				value=\"formattedNumber\" />\n				</RequestParams>\n				<Headers>\n				<Header name=\"Content-type\"\n				value=\"\'application/json\'\" />\n				</Headers>\n			</http:Request>\n			<if cond=\"httpResponse.getStatus().equals(\'success\')\">\n				<assign location=\"httpResult\" expr=\"httpResponse.getResponse().getResponseParams().get(\'responseId\')\"/>\n				<injaz:Log logLevel=\"\'info\'\" message=\"\'httpResponse= \'+httpResult\"/>\n				<assign location=\"status\" expr=\"\'success\'\"/>\n				<raise event=\"internal.REQUEST_DATA.success\"/>\n			<else/>\n				<raise event=\"internal.REQUEST_DATA.failed\"/>\n			</if>\n			\n\n\n		</transition>\n\n		<transition event=\"internal.REQUEST_DATA.success\" target=\"FINAL\"/>\n		<transition event=\"internal.REQUEST_DATA.failed\" target=\"FINAL\"/>\n\n\n	</state>\n\n\n	<state id=\"FINAL\">\n\n		<onentry>\n\n			<assign location=\"stateName\" expr=\"\'FINAL\'\"/>\n\n			<http:Respond profileID=\"\'JSON_RESPONSE\'\">\n				<ResponseParams>\n\n 					<ResponseParam name=\"status\" value=\"status\" />\n 					<ResponseParam name=\"RquestedData\" value=\"httpResult\"/>\n				</ResponseParams>\n			</http:Respond>\n\n		</onentry>\n			\n\n\n	</state>\n\n\n	</scxml>\n',1,'inquire user data','com.edafa.training.tasks.inquire_user_data',5,1,10,7),('USER_AUTH',_binary '<?xml version=\"1.0\"?>\n\n<scxml\n	xmlns=\"http://www.w3.org/2005/07/scxml\" version=\"1.0\"\n	\n	xmlns:injaz=\"http://actions.injaz.edafa.com/injaz\"\n	xmlns:http=\"http://actions.injaz.edafa.com/http\"\n	xmlns:db=\"http://actions.injaz.edafa.com/db\"\n	xmlns:kpi=\"http://actions.injaz.edafa.com/kpi\"\n	>\n\n\n	<datamodel>\n\n		<!-- Request Parameters -->\n		<data id=\"userName\" expr=\"null\"/>\n		<data id=\"password\" expr=\"null\"/>\n		<data id=\"sessionId\" expr=\"null\"/>\n		<data id=\"status\" expr=\"\'FAIL\'\"/>\n\n		<!-- log Parameters -->\n		<data id=\"stateName\" expr=\"null\"/>\n\n\n		<!-- db parameters -->\n		<data id=\"profileID\" expr=\"null\"/>\n		<data id=\"queryId\" expr=\"null\"/>\n		<data id=\"queryId2\" expr=\"null\"/>\n		<data id=\"dbResponse\" expr=\"null\"/>\n		<data id=\"dbResult\" expr=\"null\"/>\n		\n		<data id=\"hashedPass\" expr=\"null\"/>\n		<!-- http parameters -->\n		<data id=\"url\" expr=\"null\"/>\n		<data id=\"httpResponse\" expr=\"null\"/>\n		<data id=\"httpResult\" expr=\"null\"/>\n		\n		<!--kpis-->\n		<data id=\"kpiContext\" expr=\"\'login.serviceflows\'\"/>\n		<data id=\"kpiSetSystem\" expr=\"\'system_counters\'\"/>\n\n	</datamodel>\n\n\n	<state id=\"IDLE\">\n\n		<transition event=\"HttpRequest.POST\">\n\n			<assign location=\"stateName\" expr=\"\'IDLE\'\"/>\n			<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' | event=\' + _event.name + \', Request, requestParameters=\' + _event.data\" marker=\"\'CONFIDENTIAL\'\"/>\n			\n\n			<if cond=\"_event.data.containsKey(\'userName\') and _event.data.containsKey(\'password\')\">\n				<assign location=\"password\" expr=\"_event.data.get(\'password\')\"/>\n				<assign location=\"userName\" expr=\"_event.data.get(\'userName\')\"/>\n				<injaz:Hash prefix=\"\'\'\" data=\"password\" response=\"hashedPass\"/>\n				<raise event=\"internal.idle.parametersStored\"/>\n				<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' in if condition\'\"/>\n\n\n			<else/>\n				<raise event=\"internal.idle.invalidRequestParameters\"/>\n				<assign location=\"status\" expr=\"\'Invalid request parameters\'\"/>\n				<injaz:Log logLevel=\"\'info\'\" message=\"stateName + \' in else condition\'\"/>\n			</if>\n\n\n		</transition>\n\n		<transition event=\"internal.idle.invalidRequestParameters\" target=\"FINAL\"/>\n		<transition event=\"internal.idle.parametersStored\" target=\"CHECK_AUTH\"/>\n\n	</state>\n\n\n\n	<state id=\"CHECK_AUTH\">\n\n		<onentry>\n\n			<assign location=\"stateName\" expr=\"\'CHECK_AUTH\'\"/>\n			<assign location=\"profileID\" expr=\"\'userProfile\'\"/>\n			<assign location=\"queryId\" expr=\"\'getUserInfo\'\"/>\n\n			<db:Execute profileID=\"profileID\" response=\"dbResponse\">\n				<QueryParams>\n					<QueryParam name=\"$inputUserName\" value=\"userName\"/>\n				</QueryParams>\n\n				<Queries>\n						<Query id=\"getUserInfo\" enable=\"true\"/>\n				</Queries>\n\n			</db:Execute>\n\n			<assign location=\"dbResult\" expr=\"dbResponse.getResponse().getDbResponse().get(queryId).getResponseObject().getSelectedRows()\"/>\n\n			<injaz:Log logLevel=\"\'info\'\" message=\"\'dbResult= \'+dbResult\"/>\n\n			<if cond=\"dbResult.size()>0\">\n				<if cond=\"dbResult.get(0).get(\'password\').equals(hashedPass)\">\n					<injaz:GenerateID prefix=\"\'id\'\"\n						dateFormat=\"\'yyMMddHHmmssS\'\" response=\"sessionId\" />\n\n\n					<db:Execute profileID=\"profileID\">\n						<QueryParams>\n							<QueryParam name=\"$sessionID\" value=\"sessionId\"/>\n							<QueryParam name=\"$inputUserName\" value=\"userName\"/>\n						</QueryParams>\n\n						<Queries>\n								<Query id=\"putSessionId\" enable=\"true\"/>\n						</Queries>\n\n					</db:Execute>\n\n					<assign location=\"status\" expr=\"\'Success\'\"/>\n					<raise event=\"internal.check_auth.checked\"/>\n				<else/>\n					<assign location=\"status\" expr=\"\'userName or password are invalid\'\"/>\n					<raise event=\"internal.check_auth.failed\"/>\n				</if>\n			\n			<else/>\n				<assign location=\"status\" expr=\"\'userName or password are invalid\'\"/>				\n				<raise event=\"internal.check_auth.failed\"/>\n			</if>	\n		</onentry>\n\n			<transition event=\"internal.check_auth.checked\" target=\"FINAL\"/>\n			<transition event=\"internal.check_auth.failed\" target=\"FINAL\"/>\n		\n	</state>\n\n	<state id=\"FINAL\">\n\n		<onentry>\n\n			<assign location=\"stateName\" expr=\"\'FINAL\'\"/>\n\n			<http:Respond profileID=\"\'JSON_RESPONSE\'\">\n				<ResponseParams>\n					<ResponseParam name=\"sessionId\" value=\"sessionId\"/>\n 					<ResponseParam name=\"status\" value=\"status\" />\n\n				</ResponseParams>\n			</http:Respond>\n\n		</onentry>\n			\n\n\n	</state>\n\n\n</scxml>\n\n\n	',1,'check_auth','com.edafa.training.tasks.user_auth',5,2,10,7);
/*!40000 ALTER TABLE `service_flow` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-01  8:01:32
