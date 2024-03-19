# Installation Steps
- Enable BBR on both servers.
- Run './foreign-server/initial-setup.sh' on your foreign server. Reboot and verify the configurations.
- Run './foreign-server/install-service.sh' on your foreign server. Check the installed service's journal and make sure the server is up.
- Run './local-server/initial-setup.sh' on your local server. Reboot and verify the configurations.
- Run './local-server/install-routes-service.sh' on your local server. Reboot and verify that the service works after each reboot.
- Run './local-server/install-tunnel-service.sh' on your local server. Reboot and verify that the ICMP connection is set up properly. Use `curl ifconfig.io` to verify that your local server has the same IP address as your foreign server.
- Install OpenConnect using the script available at https://raw.githubusercontent.com/sfc9982/AnyConnect-Server/main/ocserv-en.sh and set up your clients.
