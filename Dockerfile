FROM python:3.9.2-buster

# Install Chromium and node.js for arm
RUN apt-get update && \
    apt-get install -y \
    chromium \
    nodejs

RUN mkdir /browsers
WORKDIR /browsers

# Download playwright for linux x86_64
RUN wget https://files.pythonhosted.org/packages/dc/bd/3b2163a4829f335f626f434915158ab7735b299d031c16f509bde37b66e2/playwright-1.15.3-py3-none-manylinux1_x86_64.whl

# Rename it so that it can be installed on arm
RUN mv playwright-1.15.3-py3-none-manylinux1_x86_64.whl playwright-1.15.3-py3-none-any.whl

RUN pip install playwright-1.15.3-py3-none-any.whl
RUN playwright install

# replace the node binary provided by playwright with a symlink to the version we just installed.
RUN rm /usr/local/lib/python3.9/site-packages/playwright/driver/node && \
    ln -s /usr/bin/node /usr/local/lib/python3.9/site-packages/playwright/driver/node

# create the hierarchy expected by playwright to find chrome
RUN mkdir -p /browsers/chromium-854489/chrome-linux
# Add a symlink to the chromium binary we just installed.
RUN ln -s /usr/bin/chromium /browsers/chromium-854489/chrome-linux/chrome
# ask playwright to search chrome in this folder
ENV PLAYWRIGHT_BROWSERS_PATH=/browsers

RUN mkdir /app
WORKDIR /app

# Copy the test file
COPY test_playwright.py /app/test_playwright.py

CMD [ "python3.9", "test_playwright.py" ]
