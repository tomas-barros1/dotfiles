function td --description "Toggle Docker service"
    if systemctl is-active --quiet docker
        echo "🛑 Parando Docker..."
        sudo systemctl stop docker
    else
        echo "🚀 Iniciando Docker..."
        sudo systemctl start docker
    end
end
