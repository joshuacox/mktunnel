FROM alpine:3.6
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV OCTOSSH_UPDATED=20170824 \
BUILD_PACKAGES='openssh-server openssh-client autossh curl ca-certificates shadow'

RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && mkdir /var/run/sshd \
  && mkdir -p /home/octossh \
  && adduser -S octossh \
  && addgroup octossh \
  && chown -R octossh. /home/octossh

WORKDIR /home/octossh

#RUN mkdir /var/run/sshd
# RUN echo 'root:screencast' | chpasswd
# RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
VOLUME /home/ssh
COPY ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
