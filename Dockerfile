FROM registry.access.redhat.com/ubi9/ubi-minimal AS builder

ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV MAMBA_DISABLE_LOCKFILE=TRUE

RUN microdnf -y update && \
    microdnf -y install tar bzip2 && \
    microdnf -y clean all

COPY environment.yaml /tmp

RUN mkdir /opt/conda && \
    curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C /usr/bin/ --strip-components=1 bin/micromamba && \
    micromamba shell init -s bash && \
    mv /root/.bashrc /opt/conda/.bashrc && \
    source /opt/conda/.bashrc && \
    micromamba activate && \
    micromamba install -c conda-forge --no-deps dask && \
    micromamba install -y -f /tmp/environment.yaml && \
    rm /tmp/environment.yaml && \
    pip install --no-dependencies trollmoves && \
    pip cache purge && \
    # Remove git with all its dependencies
    micromamba remove -y git && \
    # Remove pip, leave dependencies intact
    micromamba remove --force -y pip && \
    # Clean all mamba caches, inluding packages
    micromamba clean -af -y && \
    chgrp -R 0 /opt/conda && \
    chmod -R g=u /opt/conda

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=builder /opt/conda /opt/conda
COPY --from=builder /usr/bin/micromamba /usr/bin/
COPY entrypoint.sh /usr/bin/

USER 1001
EXPOSE 40000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
