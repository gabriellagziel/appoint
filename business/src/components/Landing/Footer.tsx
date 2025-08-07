export default function Footer() {
    return (
        <footer className="bg-gray-900 text-white py-16">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="grid md:grid-cols-4 gap-8 mb-12">
                    <div className="md:col-span-2">
                        <h3 className="text-2xl font-bold mb-4">App-Oint Business Studio</h3>
                        <p className="text-gray-300 mb-6 max-w-md">
                            Managing your business has never been easier. Appointments, clients, reports – all in one place.
                        </p>
                        <div className="flex space-x-4">
                            <a href="/login" className="btn-primary">
                                Start Now
                            </a>
                        </div>
                    </div>

                    <div>
                        <h4 className="text-lg font-semibold mb-4">Product</h4>
                        <ul className="space-y-2">
                            <li><a href="#features" className="text-gray-300 hover:text-white transition-colors">Features</a></li>
                            <li><a href="#pricing" className="text-gray-300 hover:text-white transition-colors">Pricing</a></li>
                            <li><a href="/dashboard" className="text-gray-300 hover:text-white transition-colors">Dashboard</a></li>
                        </ul>
                    </div>

                    <div>
                        <h4 className="text-lg font-semibold mb-4">Company</h4>
                        <ul className="space-y-2">
                            <li><a href="#about" className="text-gray-300 hover:text-white transition-colors">About</a></li>
                            <li><a href="#contact" className="text-gray-300 hover:text-white transition-colors">Contact</a></li>
                            <li><a href="#support" className="text-gray-300 hover:text-white transition-colors">Support</a></li>
                            <li><a href="#privacy" className="text-gray-300 hover:text-white transition-colors">Privacy</a></li>
                        </ul>
                    </div>
                </div>

                <div className="border-t border-gray-800 pt-8">
                    <div className="flex flex-col md:flex-row justify-between items-center">
                        <p className="text-gray-400 text-sm">
                            © 2024 App-Oint. All rights reserved.
                        </p>
                        <div className="flex space-x-6 mt-4 md:mt-0">
                            <a href="#terms" className="text-gray-500 text-sm hover:text-gray-400 transition-colors">Terms of Service</a>
                            <a href="#privacy" className="text-gray-500 text-sm hover:text-gray-400 transition-colors">Privacy Policy</a>
                            <a href="#cookies" className="text-gray-500 text-sm hover:text-gray-400 transition-colors">Cookie Policy</a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    )
} 