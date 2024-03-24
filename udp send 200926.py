#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 文件名：client.py

import socket  # 导入 socket 模块

def main():
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    udp_socket.sendto(b'hello world Jie Zhou', ('192.168.154.1', 6789))
    udp_socket.close()


if __name__ == "__main__":
    main()

