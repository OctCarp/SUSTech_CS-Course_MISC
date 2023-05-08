import matplotlib.pyplot as plt
from scapy.all import *


def read_ack(path, client_ip_prev, server_ip_prev, client_port_prev, server_port_prev):
    stream_info = (client_ip_prev, server_ip_prev, client_port_prev, server_port_prev)

    packets = rdpcap(path)
    times = []
    avg = []

    for pkt in packets:
        if not pkt.haslayer('TCP'):
            continue

        tcp = pkt.getlayer('TCP')
        if pkt.haslayer('IP'):
            ip = pkt.getlayer('IP')

            if (ip.src, ip.dst, tcp.sport, tcp.dport) == stream_info:
                times.append((tcp.ack, pkt.time))

            elif (ip.dst, ip.src, tcp.dport, tcp.sport) == stream_info:
                for t in times:
                    if tcp.seq == t[0]:
                        avg.append(pkt.time - t[1])

    return avg


def draw_graph(ackss):
    plt.figure(figsize=(18, 12), dpi=400)
    x_values = list(range(len(ackss)))

    ax1 = plt.subplot(2, 2, 1)
    ax2 = plt.subplot(2, 1, 2)
    ax3 = plt.subplot(2, 2, 2)

    plt.sca(ax1)
    plt.bar(x_values, ackss)
    plt.xlabel('Packet Number')
    plt.ylabel('Time')
    plt.title('RTT Time')

    cnt = 0
    tt = 0
    av = []
    for a in ackss:
        cnt = cnt + 1
        tt = tt + a
        av.append(tt / cnt)

    plt.sca(ax2)
    x_values = list(range(len(av)))
    plt.plot(x_values, av)
    plt.xlabel('Packet Number')
    plt.ylabel('Avg Time')
    plt.title('Total Average Time')

    est = []
    e = 0.2
    for a in ackss:
        e = 0.25 * e + 0.75 * a
        est.append(e)

    plt.sca(ax3)
    x_values = list(range(len(est)))
    plt.plot(x_values, est)
    plt.xlabel('Packet Number')
    plt.ylabel('Estimation Time')
    plt.title('Estimation Average Time')

    # Show the plot
    plt.show()


if __name__ == '__main__':
    a = read_ack('catch.pcapng',
                 '10.12.112.136', '20.205.243.166', 14351, 443)
    draw_graph(a)
