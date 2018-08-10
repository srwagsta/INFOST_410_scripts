FROM mysql/mysql-server:latest

RUN yum install nano -y \
&& yum install -y yum-utils \
&& yum-config-manager --enable ol7_developer_EPEL \
&& yum install -y python36 \
&& python3.6 -m venv py36env

COPY ./requirements.txt /requirements.txt

RUN source py36env/bin/activate \
&& pip install --upgrade pip \
&& pip install --no-cache-dir -r /requirements.txt \
    && rm /requirements.txt

COPY ./start /start
RUN sed -i 's/\r//' /start
RUN chmod +x /start

