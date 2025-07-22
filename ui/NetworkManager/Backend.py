import sys
import subprocess
import re
import time
from PyQt5.QtCore import QThread, pyqtSignal, QObject, QTimer, pyqtProperty, QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import qmlRegisterType, QQmlApplicationEngine


class NetworkService(QThread):
    """Background service that monitors network connectivity using ping"""
    
    # Signals to communicate with the main thread
    connectivity_changed = pyqtSignal(bool, str, float)  # connected, status, latency
    
    def __init__(self, host="8.8.8.8", interval=5):
        super().__init__()
        self.host = host
        self.interval = interval
        self.running = True
        self.connected = False
        self.latency = 0.0
        self.status_message = "Initializing..."
    
    def run(self):
        """Main thread loop that runs ping checks"""
        while self.running:
            try:
                # Execute ping command
                if sys.platform.startswith('win'):
                    # Windows ping command
                    cmd = ['ping', '-n', '1', '-w', '3000', self.host]
                else:
                    # Linux/macOS ping command
                    cmd = ['ping', '-c', '1', '-W', '3', self.host]
                
                result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
                
                if result.returncode == 0:
                    # Parse ping output for latency
                    latency = self.parse_ping_output(result.stdout)
                    self.connected = True
                    self.latency = latency
                    self.status_message = f"Connected - {latency:.1f}ms"
                else:
                    self.connected = False
                    self.latency = 0.0
                    self.status_message = "Disconnected - No response"
                    
            except subprocess.TimeoutExpired:
                self.connected = False
                self.latency = 0.0
                self.status_message = "Disconnected - Timeout"
            except Exception as e:
                self.connected = False
                self.latency = 0.0
                self.status_message = f"Error - {str(e)}"
            
            # Emit signal with current status
            self.connectivity_changed.emit(self.connected, self.status_message, self.latency)
            
            # Wait before next check
            time.sleep(self.interval)
    
    def parse_ping_output(self, output):
        """Extract latency from ping output"""
        try:
            if sys.platform.startswith('win'):
                # Windows: "time=1ms" or "time<1ms"
                match = re.search(r'time[<=](\d+(?:\.\d+)?)ms', output)
            else:
                # Linux/macOS: "time=1.234 ms"
                match = re.search(r'time=(\d+(?:\.\d+)?)\s*ms', output)
            
            if match:
                return float(match.group(1))
            return 0.0
        except:
            return 0.0
    
    def stop(self):
        """Stop the service gracefully"""
        self.running = False
        self.wait()


class NetworkMonitor(QObject):
    """QObject wrapper that exposes network status to QML"""
    
    # QML-accessible signals
    statusChanged = pyqtSignal()
    
    def __init__(self,parent):
        super().__init__()
        self._connected = False
        self._status_message = "Initializing..."
        self._latency = 0.0
        
        # Create and start the network service
        self.service = NetworkService()
        self.service.connectivity_changed.connect(self.update_status)
        self.service.start()
    
    def __del__(self):
        """Destructor - cleanup when object is destroyed"""
        self.cleanup()
    
    @pyqtProperty(bool, notify=statusChanged)
    def connected(self):
        return self._connected
    
    @pyqtProperty(str, notify=statusChanged)
    def statusMessage(self):
        return self._status_message
    
    @pyqtProperty(float, notify=statusChanged)
    def latency(self):
        return self._latency
    
    def update_status(self, connected, message, latency):
        """Update status when service emits signal"""
        changed = (self._connected != connected or 
                  self._status_message != message or 
                  abs(self._latency - latency) > 0.1)
        
        if changed:
            self._connected = connected
            self._status_message = message
            self._latency = latency
            self.statusChanged.emit()
    
    def cleanup(self):
        """Clean up resources"""
        if self.service:
            self.service.stop()

