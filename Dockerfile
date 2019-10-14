FROM python:3.7.4-alpine3.10
# Start from the base image of python:3.6.9-alpine3.10 which will be pulled directly from Docker Hub

WORKDIR /usr/src/app
# Create a specific directory and specify that all subsequent actions should be taken from this directory /usr/src/app in your image filesystem 
# never the host’s filesystem.

COPY requirement.txt ./
# copy requirement.txt from host to the present location (.) in your image. so (/usr/src/app/requirement.txt)

# [Optional]To handle the Bosch Proxy, otherwise cannot install pkg from internet
ENV http_proxy http://host.docker.internal:3128
ENV https_proxy http://host.docker.internal:3128
ENV no_proxy *.bosch.com

RUN pip install --no-cache-dir -r requirement.txt
#RUN pip3 install --no-cache-dir flask

# how to copy source code into docker
# option 1:
# COPY . .
# COPY in the rest of your app’s source code from your host to your image filesystem.
# option 2:
# COPY app.py /usr/src/app/
# COPY templates/index.html /usr/src/app/templates/
# option 3: instead of use COPY in dockerfile, use --mount in 'docker run' or volume in docker-compose file

#TODO: why?
EXPOSE 5000

#### to run the app ###
# Option 1: first, in .py do app.run(debug=True, host="0.0.0.0"), then
CMD ["python", "/usr/src/app/app.py"] 
# w/o host="0.0.0.0", it will defautlly point to localhost of this container. If so, even the host cannot access the web.


# Option 2:
# ENV FLASK_APP=app.py

# CMD flask run --host=0.0.0.0
