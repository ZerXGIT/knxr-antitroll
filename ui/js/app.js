function main() {
    return {
        show: false,
        minleft: 60,
        
        listen() {
            window.addEventListener('message', (event) => {
                let data = event.data

                switch(data.type) {
                    case 'show':
                        this.show = data.show;
                        break;

                    case 'update':
                        this.minleft = data.minleft;
                        break;
                }
            })
        }
    }
}