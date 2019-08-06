# pycharm-docker-via-ssh
Connect to a Python interpreter inside the docker container which is running on the remote server

## Dockerfile modification
* Install OpenSSH:
   
    `apt-get update && apt-get install -y openssh-server`

* Create `sshd` folder. Required to start a SSH daemon:
    
    `mkdir /var/run/sshd`
    
* Setting a password (current `yourpass`) that will be used during logging:

    `RUN echo 'root:yourpass' | chpasswd`
    
*  Allow logging under the root:
    
    `RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config`
    
*  SSH login fix. Otherwise user is kicked off after login:

    `RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd`
    
* Docker port opening:
    
    `EXPOSE 22`

* Start the SSH service as a daemon:
    
    `CMD ["/usr/sbin/sshd", "-D"]`
    
Docker container start: `make build && make run`
    
## Use cases
In order to demonstrate, the host port (to docker) is specified as in the Makefile: `9999`.

### Docker is runnig `locally`
* Commands:

    `nothing`
    
* Check: 

    `local:~$ ssh root@localhost -p 9999`
    
    `docker:~$ python /pycharm-docker-via-ssh/src/test.py`

### Docker is running on the remote `ml1` server on the `same` network
* Commands:

    `nothing`
    
* Check: 

    `local:~$ ssh root@xx.xx.xx.xx -p 9999`
    
    `docker:~$ python /pycharm-docker-via-ssh/src/test.py`

### Docker is running on the remote `ml1` server on `another` network
* Commands:
    
    `local:~$ ssh -L 9991:localhost:9999 ml1`

* Check: 

    `local:~$ ssh root@localhost -p 9991`
    
    `docker:~$ python /pycharm-docker-via-ssh/src/test.py`

### Docker is running on the remote `mlx` server, which can be accessed through a `ml1` transit server
* Commands:
    
    `mlx:~$ ssh -R 9992:localhost:9999 ml1`
    
    `local:~$ ssh -L 9991:localhost:9992 ml1`
    
* Check: 

    `local:~$ ssh root@localhost -p 9991`
    
    `docker:~$ python /pycharm-docker-via-ssh/src/test.py`



Etc...
In the PyCharm configuration, connect to the docker through the `localhost` and the desired `port`.
Use `root` username and password which which is defined in Dockerfile