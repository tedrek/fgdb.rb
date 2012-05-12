--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('roles_id_seq', 21, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE roles DISABLE TRIGGER ALL;

COPY roles (id, name, created_at, updated_at, notes) FROM stdin;
1	ADMIN	\N	2012-04-07 14:45:37.149819	Can modify user accounts, assign any role to users and has unrestricted access to the entire database
6	BEAN_COUNTER	2008-04-15 09:57:59.126816	2012-04-07 14:45:37.215682	Can modify past inventory and control settings, in addition to unrestricted access to all transaction types
12	BUILD_INSTRUCTOR	2011-02-26 00:30:06.106766	2012-04-07 14:45:37.236335	Can modify contact information, schedule volunteers and sign off printme spec sheets
5	CONTACT_MANAGER	\N	2012-04-07 14:45:37.257127	Can modify contact information and create disbursements
19	CREATE_LOGIN	2012-03-09 18:42:28.142362	2012-04-07 14:45:37.27848	Can create database accounts for new users and grant them any of their own privilege roles
7	DONATION_ADMIN	2008-04-15 09:59:30.598238	2012-04-07 14:45:37.295126	Can change donation records
2	FRONT_DESK	\N	2012-04-07 14:45:37.316981	Can create and change disbursement records, but can only create donation and recycling records
14	GRANT_MANAGER	2011-05-07 09:28:19.171418	2012-04-07 14:45:37.334862	Can change disbursements
20	HR	2012-03-10 11:23:45.460013	2012-04-07 14:45:37.351183	Can modify worker records and staff hours
9	RECYCLINGS	2008-12-22 09:00:53.862156	2012-04-07 14:45:37.368948	Can create recyclings
16	RECYCLING_ADMIN	2011-11-01 19:03:34.948092	2012-04-07 14:45:37.387371	Can create or change recyclings
10	SKEDJULNATOR	2009-02-06 23:48:33.442751	2012-04-07 14:45:37.407267	Can modify worker information and schedule staff shifts
18	STAFF_HOURS	2011-12-17 02:49:30.845684	2012-04-07 14:45:37.427687	Can log staff hours (needed only if no worker record is associated)
4	STORE	\N	2012-04-07 14:45:37.448245	Can create sales, disbursements and returns, in addition to modifying contact information
8	STORE_ADMIN	2008-04-15 09:59:35.107392	2012-04-07 14:45:37.466428	Can change sales and returns
13	STORE_CREDIT	2011-04-01 19:27:44.954939	2012-04-07 14:45:37.547237	Can issue store credit
11	TECH_SUPPORT	2009-08-12 01:45:57.971818	2012-04-07 14:45:37.567127	Can create disbursements and returns, in addition to viewing sales
17	VIEW_VOLUNTEER_SCHEDULE	2011-11-18 22:38:03.314853	2012-04-07 14:45:37.586436	Can view the volunteer schedule read-only
3	VOLUNTEER_MANAGER	\N	2012-04-07 14:45:37.605862	Can create disbursements, modify contact information and schedule or log volunteer hours
15	ADMIN_VOLSKEDJ	2011-06-04 15:52:53.76601	2012-04-07 14:50:09.85958	Can modify available volunteer slots and generate from the template schedules
21	COLLECTIVE	\N	\N	This role will give access to a report which summarizes worked staff hours.
\.


ALTER TABLE roles ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

