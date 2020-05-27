FROM jacosta000/windows-node-git

# This image requires .ssh folder in the same folder as the other container files.  This is related to ssh key for git
# https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops&tabs=current-page
COPY .ssh Users\\ContainerAdministrator\\.ssh

#Build args passed from .env file through docker-compose
ARG CLIENT_DIR=%CLIENT_DIR%
ARG BRANCH=%BRANCH%

RUN mkdir C:\repos
WORKDIR C:\\repos

RUN git clone git@ssh.dev.azure.com:v3/<REST OF GIT URL>
# WORKDIR <new folder>
RUN git fetch \
&& git checkout %BRANCH%

WORKDIR FrontEnd\\Build
RUN npm install

WORKDIR ..\\Clients
WORKDIR $CLIENT_DIR
RUN npm install && gulp --minify false --env Default

WORKDIR <app directory>

# Install NSSM to run http-server as a Windows service
RUN choco install nssm -y \
&& nssm install httpsrv c:\Users\ContainerAdministrator\AppData\Roaming\npm\http-server.cmd %CD% \
&& nssm start httpsrv