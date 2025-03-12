### 꾹꾹 clientend 폴더 입니다.

# Flutter 및 Android 에뮬레이터 DevContainer

이 프로젝트는 VSCode DevContainer 환경에서 Flutter 개발과 Android 에뮬레이터를 사용할 수 있도록 구성된 환경입니다.

## 사전 요구사항

- Docker 설치
- VSCode 설치
- VSCode의 Remote - Containers 확장 설치
- X11 서버 설치 (Windows의 경우 VcXsrv, macOS의 경우 XQuartz)

## 설치 및 사용 방법

### 1. 호스트 시스템 설정

#### Linux 사용자
- KVM 설정: 
```bash
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser $USER kvm
sudo chmod 666 /dev/kvm
```

#### Windows 사용자
- WSL2 설치 및 설정
- VcXsrv 설치 후 실행 (추가 액세스 권한 허용)
- 환경 변수 설정 (PowerShell):
```powershell
$env:DISPLAY="`$(hostname).local:0.0"
```

#### macOS 사용자
- XQuartz 설치 및 실행
- 환경 변수 설정:
```bash
export DISPLAY=:0
xhost + localhost
```

### 2. 프로젝트 설정

1. 이 저장소를 클론합니다.
2. VSCode로 프로젝트 폴더를 엽니다.
3. VSCode가 DevContainer를 감지하면 "Reopen in Container"를 클릭합니다.
4. 컨테이너가 빌드되고 시작될 때까지 기다립니다 (첫 실행 시 시간이 오래 걸릴 수 있습니다).

### 3. 에뮬레이터 실행

컨테이너 내에서 다음 명령을 실행합니다:

```bash
chmod +x run_emulator.sh
./run_emulator.sh
```

### 4. Flutter 앱 실행

에뮬레이터가 실행된 후, Flutter 앱을 다음과 같이 실행합니다:

```bash
flutter create my_app
cd my_app
flutter run
```

## 문제 해결

### X11 연결 문제
- 에러 메시지: `cannot connect to X server`
  - 해결: 호스트에서 `xhost +local:docker` 명령 실행

### KVM 권한 문제
- 에러 메시지: `/dev/kvm device permission denied`
  - 해결: 호스트에서 `sudo chmod 666 /dev/kvm` 명령 실행

### 에뮬레이터 시작 실패
- Android 에뮬레이터가 시작되지 않는 경우:
  - 헤드리스 모드 대신 일반 모드로 시도:
    ```bash
    $ANDROID_HOME/emulator/emulator -avd Pixel_API_33
    ```

## 주의사항

- 이 설정은 GUI 기반 에뮬레이터 표시를 위해 호스트의 X11 서버에 의존합니다.
- 성능 문제가 발생할 수 있으므로, 리소스 할당을 충분히 해주세요.
- Docker 컨테이너에서 에뮬레이터를 실행하는 것은 네이티브에 비해 성능이 떨어질 수 있습니다.