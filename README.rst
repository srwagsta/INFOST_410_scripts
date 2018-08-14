INFOST 410: Database Info Retrvl Syst
=====================================

Assignments for INFOST 410 at UMW. This repo contains a Docker compose file that allows the execution of MySql scripts within
a Docker container and outputs the results of execution formatted with the corresponding SQL statement in PDF format.
Setup, build, and execution instructions are below.

:License: Apache Software License 2.0


Setup
-----

File paths, output paths, and output file names are stored in the *FILE_DICTIONARY* dictionary in *execute_sql_script.py*.
Previous script files have been included under *sql_scripts* directory. If you need to modify these scripts there
is no need to rename. By default all PDF output will be placed in the *output_file* directory.


Docker Commands
---------------

Building the Image
^^^^^^^^^^^^^^^^^^

* Navigate to the *Docker* directory

* To build the image, use this command::

    $ docker-compose -f compose.yml build

This will be the Docker image based on the compose.yml file

Running the containers
^^^^^^^^^^^^^^^^^^^^^^

To run the containers and generate the PDF output file use,::

    $ docker-compose -f compose.yml up --abort-on-container-exit


Explanation on container run
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When this container runs it spins up a MySql Server container and an Ubuntu based Python3.6 container. The Python
container waits until the MySql contain is running. Then it will execute the *execute_sql_script.py* script. This will
then connect to the MySql container and run the *Premier.Script.sql* against the DB. After this it will run each of the
assignment scripts and place the PDF formatted output in the *output_files* directory. After each of the assignment
scripts the DB is recreated using the *Premier.Script.sql*. Once all the assignment scripts have been run the Python3
container will exit, and because of the *--abort-on-container-exit* flag used when launching the containers the MySql
container will also exit. The PDF files remain and there is no need to worry about containers running in the background.
To confirm all containers have exited, use this command::

  $ docker ps


Demonstrating Docker Networks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As an example of Networking within Docker and Docker Compose, the *compose.yml* file contains two Networks
(*frontend* and *backend*) currently both the MySql container and the Ubuntu container use the *backend*
network. *This does cause Docker to issue a warning, but this is only a demonstration so feel free to ignore
the warning.* If you change either of the container to the *backend* network from withing the *compose.yml*
file you will notice that the Ubuntu container will continue to look for the MySql contain but it will never
find the database. This is because now they are on different networks and the Ubuntu container can no longer
resolve the ip address for the database via the *mysql* reference. See more information on `Docker Networks`_.

.. _`Docker Networks`: https://docs.docker.com/compose/networking/


Docker
^^^^^^

See detailed `Docker documentation`_.

.. _`Docker documentation`: https://docs.docker.com/get-started/



