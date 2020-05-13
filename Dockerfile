FROM ortussolutions/commandbox:lucee5-3.0.2

COPY ./app /app
COPY lucee_build.env /app/.env

RUN cd /app && box install \
	&& box install commandbox-dotenv