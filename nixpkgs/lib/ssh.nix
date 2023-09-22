{ secrets, flakeInputs, ... }:
{

      mkSshMatchBlock = m: {
       user = secrets.nova-gitlab-runner-1.userName;
       identityFile = secrets.nova-runner-1.sshKey;
       hostname = m.hostname;
       identitiesOnly = true;
       extraOptions.userKnownHostsFile = "${flakeInputs.nova-ci}/configs/prod/ssh_known_hosts";
       port = m.port;
       # 
       match = "host=${m.hostname},${m.runnerName}";
      };
 }
