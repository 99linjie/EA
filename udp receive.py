#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 文件名：client.py

import socket  # 导入 socket 模块

def main():
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    localhost_addr = ('192.168.154.1', 6789)
    udp_socket.bind(localhost_addr)
    recv_data = udp_socket.recvfrom(1024)
    recv_msg = recv_data[0]
    send_addr = recv_data[1]

    print('{}:{}'.format(str(send_addr), recv_msg.decode('utf-8')))
    udp_socket.close()


if __name__ == "__main__":
    main()

