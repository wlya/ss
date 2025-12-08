mv /ss/ssserver.service /etc/systemd/system/ssserver.service

sudo systemctl daemon-reload

systemctl daemon-reload
systemctl enable ssserver.service
systemctl start ssserver.service
