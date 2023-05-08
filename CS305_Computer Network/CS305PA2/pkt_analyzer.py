from scapy.all import *
from scapy.layers.http import HTTPRequest, HTTPResponse

conf.verb = 0

'''
This is the skeleton code for the packet analyzer. You will need to complete the functions below. Note that 
you cannot modify the function signatures. You can add additional functions if you wish.
'''


def packet_info(pcap_file, save_file):
    '''

    :param pcap_file: path to pcap file
    :param save_file: path to save file of results
    :return: not specified
    '''
    packets = rdpcap(pcap_file)

    conn_info = []
    with open(save_file, 'w') as f:
        for pkt in packets:
            if pkt.haslayer('TCP') and pkt.haslayer('IP'):
                cur = (pkt['IP'].src, pkt['TCP'].sport, pkt['IP'].dst, pkt['TCP'].dport)

                if cur not in conn_info:
                    f.write("{}:{} -> {}:{}\n".format(cur[0], cur[1], cur[2], cur[3]))
                    conn_info.append(cur)


# iterate over each packet in the pcap file
def tcp_stream_analyzer(file, savefile, client_ip_prev, server_ip_prev, client_port_prev, server_port_prev):
    """
    :param file: path to pcap file
    :param savefile: path to save file of analysis results
    :param client_ip_prev: ip address of client of TCP stream waiting for analysis
    :param server_ip_prev: ip address of server of TCP stream waiting for analysis
    :param client_port_prev: port of client of TCP stream waiting for analysis
    :param server_port_prev: port of server of TCP stream waiting for analysis
    :return: not specified
    """

    stream_info = (client_ip_prev, server_ip_prev, client_port_prev, server_port_prev)

    cnt = 0
    packets = rdpcap(file)
    with open(savefile, 'w') as f:
        f.write("Server : {}:{} <-> Client : {}:{} \n".format(
            stream_info[1], stream_info[3], stream_info[0], stream_info[2]))

        c_sq = 0
        s_sq = 0
        for pkt in packets:
            if not pkt.haslayer('TCP'):
                continue

            tcp = pkt.getlayer('TCP')
            if pkt.haslayer('IP'):
                ip = pkt.getlayer('IP')

                if (ip.src, ip.dst, tcp.sport, tcp.dport) == stream_info:
                    cnt = cnt + 1
                    if c_sq == 0 or tcp.flags == ('S' or 'SA'):
                        c_sq = tcp.seq
                    f.write(
                        "Client -> Server Num: {}, SEQ: {}, ACK: {} {}\n".format(
                            cnt, tcp.seq - c_sq, tcp.ack - s_sq, tcp.flags))
                elif (ip.dst, ip.src, tcp.dport, tcp.sport) == stream_info:
                    cnt = cnt + 1
                    if s_sq == 0 or tcp.flags == ('S' or 'SA'):
                        s_sq = tcp.seq

                    f.write(
                        "Server -> Client Num: {}, SEQ: {}, ACK: {} {}\n".format(
                            cnt, tcp.seq - s_sq, tcp.ack - c_sq, tcp.flags))

            elif pkt.haslayer('IPv6'):
                ipv6 = pkt.getlayer('IPv6')

                if (ipv6.src, ipv6.dst, tcp.sport, tcp.dport) == stream_info:
                    cnt = cnt + 1
                    if c_sq == 0 or tcp.flags == ('S' or 'SA'):
                        c_sq = tcp.seq
                    f.write(
                        "Client -> Server Num: {}, SEQ: {}, ACK: {} {}\n".format(
                            cnt, tcp.seq - c_sq, tcp.ack - s_sq, tcp.flags))

                elif (ipv6.dst, ipv6.src, tcp.dport, tcp.sport) == stream_info:
                    cnt = cnt + 1
                    if s_sq == 0 or tcp.flags == ('S' or 'SA'):
                        s_sq = tcp.seq

                    f.write(
                        "Server -> Client Num: {}, SEQ: {}, ACK: {} {}\n".format(
                            cnt, tcp.seq - s_sq, tcp.ack - c_sq, tcp.flags))


def http_stream_analyzer(pcapfile, savefile, client_ip_prev, server_ip_prev, client_port_prev):
    """

    :param pcapfile: path to pcap file
    :param savefile: path to save file of analysis results
    :param client_ip_prev: ip address of client of HTTP stream waiting for analysis
    :param server_ip_prev: server ip address of HTTP stream waiting for analysis
    :param client_port_prev: port of client of HTTP stream waiting for analysis
    :return: not specified
    """

    stream_info = (client_ip_prev, server_ip_prev, client_port_prev, 80)
    packets = rdpcap(pcapfile)

    with open(savefile, 'w') as f:
        # f.write("Server : {}:{} <-> Client : {}:{} \n".format(
        #     stream_info[1], stream_info[3], stream_info[0], stream_info[2]))

        for pkt in packets:
            tcp = pkt.getlayer('TCP')
            ip = pkt.getlayer('IP')

            if (ip.src, ip.dst, tcp.sport, tcp.dport) == stream_info:
                req = pkt.getlayer(HTTPRequest)
                try:
                    f.write('{} {} {}\n'.format(req.Method.decode('ascii'),
                                                req.Path.decode('ascii'),
                                                req.Http_Version.decode('ascii')))
                except AttributeError:
                    f.write('..NO HEADER..\n')


            elif (ip.dst, ip.src, tcp.dport, tcp.sport) == stream_info:
                res = pkt.getlayer(HTTPResponse)

                try:
                    f.write('{} {} {}\n'.format(res.Http_Version.decode('ascii'),
                                                res.Status_Code.decode('ascii'),
                                                res.Reason_Phrase.decode('ascii')))
                except AttributeError:
                    f.write('..NO HEADER..\n')


if __name__ == '__main__':
    packet_info('TCP_PKTS.pcap', 'resource/out/PACKET_INFO.txt')

    tcp_stream_analyzer('TCP_PKTS.pcap', 'resource/out/TCP_INFO.txt',
                        '10.26.184.140', '13.107.42.12', 1433, 443)

    tcp_stream_analyzer('TCP_PKTS.pcap', 'resource/out/TCPv6_INFO.txt',
                        "2001:da8:201d:1109::1321", "240e:c3:4000:4::dca9:9823", 12703, 443)

    http_stream_analyzer('HTTP_.pcap', 'resource/out/HTTP_INFO.txt',
                         "10.25.217.154", "113.246.57.9", 53564)
    '''
    You can call functions here to test your code.
    '''
