# Use the official prebuilt Juice Shop image.
# Pros: tiny Dockerfile, very reliable, no native build headaches.
# You can still scan this image with Trivy and run ZAP against it.
FROM bkimminich/juice-shop:latest

# Juice Shop listens on 3000 by default
EXPOSE 3000

# The image already defines CMD, so no override needed.
# Kept intentionally minimal on purpose.
