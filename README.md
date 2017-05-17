# Docker_Android
AndroidのビルドがとりあえずできるDockerFile

```
cp {path}/{to}/{androidSDK}/licenses ./android-sdk-license
docker build -t {name} .
docker run -p 8080:8080 -p 50000:50000 -e JAVA_OPTS='-Duser.timezone=Asia/Tokyo -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8' -v `pwd`/{path}/{to}/{volume}:/var/{path}/{to}/{volume} -d -it {name}
```
