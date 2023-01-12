FROM gcr.io/google-appengine/python

WORKDIR dbt_project

# Create a virtualenv for dependencies. This isolates these packages from
# system-level packages.
# Use -p python3 or -p python3.7 to select python version. Default is version 2.
RUN virtualenv /env -p 3.9.2

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Copy the application's requirements.txt and run pip to install all
# dependencies into the virtualenv.
#ADD requirements.txt /app/requirements.txt
#RUN pip install -r /app/requirements.txt

# Add the application source code.
COPY ./dbt-source/dbt_project .

RUN dbt debug --config-dir

CMD ["dbt"]

ARG USER=gdap
RUN adduser ${USER} --disabled-password \
&& chwon ${USER}:${USER} -R . 

