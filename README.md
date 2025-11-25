# simple-exec-ui

First, to run the program, clone the project:
```bash
git clone https://github.com/onhangocnhu/simple-exec-ui.git
cd simple-exec-ui
```

## Run the frontend
```bash
cd frontend
npm install
npm start
```

## Run the backend
```bash
cd backend
cp .env.example .env
```

Then remember to config your database with SQL Server Authentication, includes username and password. 

**Notes: You need to enable TCP/IP connection and add port number ``1433`` as well**

```bash
npm start
```

In this project, we will use the database ``RAPPHIM``.


## Configure the SQL Server Authentication
1. Open ``SQL Server 2022 Configuration Management``
2. Click on ``SQL Server Network Configuration``
3. Click on ``Protocols for SQLEXPRESS``
4. ``Enabled`` TCP/IP and Shared Memory by double click on them
5. When double click on ``TCP/IP``, go to the ``IP Addresses`` section
6. Change/add the ``TCP Port`` of ``IPAll`` to ``1433``
7. Delete ``TCP Dynamic Ports``, keep it empty
8. Outside, open ``SSMS`` to connect to your database
9. In ``SQL Server 2022 Configuration Management`` again,  click on ``SQL Server Services``
10. Right-click on the first line: ``SQL Server (...)``
11. ``Restart`` 
12. Right-click on ``SQL Server Browser`` and choose ``Properties``
13. On ``Service`` section, click on ``Start Mode`` and change it to ``Manual``

14. Outside, open ``SSMS``
15. After connecting to the server, right click on the server name at ``Object Explorer`` and choose ``Properties``
16. Go to the ``Security`` section, choose ``SQL Server and Windows Authentication mode`` at ``Server authentication`` part
17. CLick ``OK``
18. Expand the ``Security`` tab below your server name
19. Right-click on the ``Logins`` tab, choose ``New Login...``
20. Fill out ``Login name``, choose ``SQL authentication`` and add your ``Password``
21. On the ``Securables`` tab, choose ``Searchs``, click on ``All objects of the type``
22. Save the user

23. Create new query and run this code
```sql
USE RAPPHIM;
GRANT SELECT, INSERT, UPDATE, DELETE TO <yourUser>;
GRANT EXECUTE TO <yourUser>;
```

23. Restart the ``SQL Server (...)`` and ``SQL Server Browser`` like steps 10. and 11.
24. Open your SSMS, connect to your server with SQL Authentication to see if it works!