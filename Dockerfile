FROM continuumio/anaconda3:2023.11

WORKDIR /app

COPY environment.yml /tmp/environment.yml

RUN conda env create -f /tmp/environment.yml

RUN echo "conda activate my_environment" > ~/.bashrc && \
    conda install -n my_environment -c conda-forge notebook

EXPOSE 8888

CMD ["bash", "-c", "source activate my_environment && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root"]

# docker build -t anaconda-jupyter-project .
# docker run -p 8888:8888 -v $(pwd):/app anaconda-jupyter-project
