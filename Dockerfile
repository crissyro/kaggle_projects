FROM continuumio/miniconda3:latest

WORKDIR /app

RUN conda create -n my_env python=3.12 -y
RUN conda install -n my_env -c conda-forge notebook -y

ENV PATH=/opt/conda/envs/my_env/bin:$PATH

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]


# docker build -t anaconda-jupyter-project .
# docker run -p 8888:8888 -v $(pwd):/app anaconda-jupyter-project
