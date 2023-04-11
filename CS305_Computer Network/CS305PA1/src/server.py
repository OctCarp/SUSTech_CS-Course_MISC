import os
import socket

s = socket.socket()
s.bind(("127.0.0.1", 52305))
s.listen(5)

while True:
    client, addr = s.accept()
    client.send(b"220 12110304 ready.\r\n")

    line = client.recv(1024).decode('ascii').strip()

    on_login = False
    is_login = False
    is_super = False
    data_sock = None
    user = None

    work_path = "data/"
    while line != "QUIT":
        if not is_login:
            if line[:4] == "USER":
                try:
                    u_name = line[5:]
                    if u_name == "anonymous":
                        client.send(b"230 Anonymous User Login successful.\r\n")
                        is_login = True
                        is_super = True
                    else:
                        for line in open("users/userdata.txt"):
                            ud = line.split(' ')
                            if ud[0] == u_name:
                                client.send(b"331 User name okay, need password.\r\n")
                                user = ud
                                on_login = True
                                break

                        if not on_login:
                            client.send(b"430 Invalid username or password.\r\n")

                except IndexError:
                    client.send(b"430 Invalid username or password.\r\n")

            elif on_login and line[:4] == "PASS":
                if line[5:] == user[1]:
                    is_login = True
                    if user[2] == 'S\n':
                        is_super = True
                        client.send(b"230 Super User Login successful.\r\n")
                    else:
                        is_super = False
                        client.send(b"230 General User Login successful.\r\n")

                else:
                    client.send(b"430 Invalid username or password.\r\n")

            else:
                client.send(b"530 Not logged in.\r\n")

        elif line[:4] == "USER":
            try:
                u_name = line[5:]
                if u_name == "anonymous":
                    client.send(b"230 Anonymous User Login successful.\r\n")
                    is_login = True
                    is_super = True
                else:
                    for line in open("users/userdata.txt"):
                        ud = line.split(' ')
                        if ud[0] == u_name:
                            client.send(b"331 User name okay, need password.\r\n")
                            user = ud
                            on_login = True
                            break

                    if not on_login:
                        client.send(b"430 Invalid username or password.\r\n")

            except IndexError:
                client.send(b"430 Invalid username or password.\r\n")

        elif on_login and line[:4] == "PASS":
            if line[5:] == user[1]:
                is_login = True
                if user[2] == 'S\n':
                    is_super = True
                    client.send(b"230 Super User Login successful.\r\n")
                else:
                    is_super = False
                    client.send(b"230 General User Login successful.\r\n")

            else:
                client.send(b"430 Invalid username or password.\r\n")

        elif line[:4] == "TYPE":
            if line[5] == 'I':
                data_type = 'I'
                client.send(b"200 Type set to binary.\r\n")

        elif line[:4] == "PORT":
            a_l = line[5:].split(',')
            client_ip = a_l[0] + '.' + a_l[1] + '.' + a_l[2] + '.' + a_l[3]
            client_port = int(a_l[4]) * 256 + int(a_l[5])

            if len(a_l) != 6:
                client.send(b"504 Command not implemented for that parameter.\r\n")
            else:
                try:
                    data_sock = socket.socket()
                    data_sock.connect((client_ip, client_port))
                    client.send(b"200 Active data connection established.\r\n")
                except ConnectionRefusedError:
                    data_sock.close()
                    client.send(b"425 Can't open data connection.\r\n")

        elif line[:4] == "EPRT":
            a_l = line[5:].split('|')
            client_ip = a_l[2]
            client_port = int(a_l[3])

            if len(a_l) != 5:
                client.send(b"504 Command not implemented for that parameter.\r\n")
            else:
                try:
                    data_sock = socket.socket()
                    data_sock.connect((client_ip, client_port))
                    client.send(b"200 Active data connection established.\r\n")
                except ConnectionRefusedError:
                    data_sock.close()
                    client.send(b"425 Can't open data connection.\r\n")

        elif line[:4] == "STOR":
            filename = line[5:]
            if is_super:
                try:
                    with open(work_path + filename, 'wb') as f:
                        client.send(b"125 Data connection already open. Transfer starting.\r\n")
                        data = data_sock.recv(1024)
                        f.write(data)
                        client.send(b"226 Transfer complete.\r\n")
                except PermissionError:
                    client.send(b"553 Requested action not taken. File name not allowed.\r\n")

                data_sock.close()
            else:
                client.send(b"532 Need super account for storing files.\r\n")

        elif line[:4] == "RETR":
            filename = line[5:]

            try:
                with open(work_path + filename, 'rb') as f:
                    client.send(b"125 Data connection already open. Transfer starting.\r\n")
                    data_sock.send(f.read())
                    client.send(b"226 Transfer complete.\r\n")
            except FileNotFoundError:
                client.send(b"550 Requested action not taken. File unavailable.\r\n")

            data_sock.close()

        elif line[:4] == "SIZE":
            filename = line[5:]

            try:
                with open(work_path + filename, 'rb') as f:
                    size = f.seek(0, os.SEEK_END)
                    client.send(b"Size is %d.\r\n" % size)
            except FileNotFoundError:
                client.send(b"550 Requested action not taken. File unavailable.\r\n")

        elif line[:4] == "SYST":
            client.send(b"12110304 powered by Windows 10.\r\n")

        elif line[:3] == "PWD":
            client.send((work_path + '\r\n').encode())

        elif line[:4] == "LIST":
            cnt = 1
            list_data = ''
            for file_name in os.listdir(work_path):
                list_data += "%d: %s.\n" % (cnt, file_name)
                cnt += 1

            client.send(list_data.encode())

        else:
            client.send(b"502 Command not implemented\r\n")

        line = client.recv(1024).decode('ascii').strip()
        print(line)

    client.send(b"221 Goodbye.\r\n")
    client.close()
