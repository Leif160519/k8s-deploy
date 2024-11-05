FROM jumpserver/koko:v2.28.21

RUN wget -c https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz -O /tmp/kubecolor_0.0.25_Linux_x86_64.tar.gz \
    && cd /tmp \
    && tar -zxvf /tmp/kubecolor_0.0.25_Linux_x86_64.tar.gz \
    && cp /tmp/kubecolor /usr/local/bin/ \
    && find /tmp/* -delete \
    && chmod +x /usr/local/bin/kubecolor

RUN echo 'alias kubectl=kubecolor' >> /opt/kubectl-aliases/.kubectl_aliases

