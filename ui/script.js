const App = Vue.createApp({
    data() {
        return {
            activeButton: 'car',
            gName: "asder",
            searchQuery: '',
            vehgarage: [],
            vehimpound: [],
            selectedCar: null,
            showAlert: false,
            alertMessage: ''
        }
    },
    created() {
        console.log("Vue instance created");
        if (this.vehgarage.length > 0) {
            this.selectedCar = this.vehgarage[0];
        }
    },
    computed: {
        filteredCars() {
            let cars = this.activeButton === 'car' ? this.vehgarage : this.vehimpound;
            return cars.filter(car => {
                const label = car.label ? car.label.toLowerCase() : '';
                const plate = car.plate ? car.plate.toLowerCase() : '';
                const query = this.searchQuery.toLowerCase();
                return label.includes(query) || plate.includes(query);
            });
        }
    },
    methods: {
        close() {
            const alertElement = document.querySelector('.animate__zoomIn');
            if (alertElement) {
                alertElement.classList.remove('animate__zoomIn');
                alertElement.classList.add('animate__zoomOut');
                this.showAlert = false;
                setTimeout(() => {
                    fetch(`https://${GetParentResourceName()}/exit`);
                }, 500);
            }
            this.selectedCar = null;

        },
        takeOut(vehicle, plate) {
            const alertElement = document.querySelector('.animate__zoomIn');
            if (alertElement) {
                alertElement.classList.remove('animate__zoomIn'); // Remove zoom-in class
                alertElement.classList.add('animate__zoomOut');
                this.showAlert = false;
                setTimeout(() => {
                    fetch(`https://${GetParentResourceName()}/takeOut`, {
                        method: 'POST',
                        body: JSON.stringify({
                            vehicle: vehicle,
                            plate: plate
                        })
                    });
                }, 500);
            }
            this.selectedCar = null;
        },
        takeOutImp(vehicle, plate) {
            fetch(`https://${GetParentResourceName()}/takeOutImp`, {
                method: 'POST',
                body: JSON.stringify({
                    vehicle: vehicle,
                    plate: plate
                })
            });
            this.selectedCar = null;

        },
        hideAlert() {
            const alertElement = document.querySelector('.alert');
            if (alertElement) {
                alertElement.classList.add('animate__fadeOutUp');
                setTimeout(() => {
                    this.showAlert = false;
                }, 1000);
            }
        },
        activateButton(button) {
            if (button === 'impound' && this.vehimpound.length === 0) {
                this.showAlert = true;
                this.alertMessage = "No vehicles in impound.";
                return;
            }
            if (button === 'car' && this.vehgarage.length === 0) {
                this.showAlert = true;
                this.alertMessage = "No vehicles in garage.";
                this.activeButton = 'impound';
                return;
            }

            this.activeButton = button;
            this.selectedCar = this.filteredCars.length > 0 ? this.filteredCars[0] : null;
            console.log("Active button:", this.activeButton);
            console.log("Filtered cars:", this.filteredCars);
        },
        handleKeyDown(event) {
            if (event.key === "Escape") {
                this.close();
            }
        },
        selectCar(car) {
            this.selectedCar = car;
        }
    },
    mounted() {
        console.log("Vue instance mounted");
        var _this = this;
        window.addEventListener("message", function (event) {
            if (event.data.type === "show_Garage") {
                document.body.style.display = event.data.enable ? "block" : "none";
                if (event.data.enable) {
                    const alertElement = document.querySelector('.animate__zoomOut');
                    if (alertElement) {
                        alertElement.classList.remove('animate__zoomOut');
                        alertElement.classList.add('animate__zoomIn');
                    }
                }
            } else if (event.data.type === "setvehicles") {
                _this.vehgarage = event.data.vehicles;
                _this.vehimpound = event.data.Imp_Vehicles;
                _this.gName = event.data.gName;
    
                if (_this.vehgarage.length === 0) {
                    _this.activeButton = 'impound';
                }
            } else if (event.data.type === "setImpoundedvehicles") {
                _this.vehimpound = event.data.Imp_Vehicles;
            }
        });
    
        window.addEventListener("keydown", this.handleKeyDown);
    },
}).mount("#app");