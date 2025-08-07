"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CheckCircle, Globe, Languages, TrendingUp } from "lucide-react"
import { useState } from "react"

// Mock localization data
const mockLanguages = [
    { code: "en", name: "English", status: "complete", translatedKeys: 1250, totalKeys: 1250, lastUpdated: "2024-01-20" },
    { code: "es", name: "Spanish", status: "complete", translatedKeys: 1250, totalKeys: 1250, lastUpdated: "2024-01-19" },
    { code: "fr", name: "French", status: "in_progress", translatedKeys: 980, totalKeys: 1250, lastUpdated: "2024-01-18" },
    { code: "de", name: "German", status: "in_progress", translatedKeys: 850, totalKeys: 1250, lastUpdated: "2024-01-17" },
    { code: "zh", name: "Chinese", status: "pending", translatedKeys: 450, totalKeys: 1250, lastUpdated: "2024-01-15" },
    { code: "ja", name: "Japanese", status: "pending", translatedKeys: 320, totalKeys: 1250, lastUpdated: "2024-01-14" }
]

const mockTranslationKeys = [
    { key: "welcome_message", en: "Welcome to App-Oint", es: "Bienvenido a App-Oint", fr: "Bienvenue sur App-Oint", status: "translated" },
    { key: "appointment_booking", en: "Book Appointment", es: "Reservar Cita", fr: "Prendre Rendez-vous", status: "translated" },
    { key: "cancel_appointment", en: "Cancel Appointment", es: "Cancelar Cita", fr: "Annuler Rendez-vous", status: "translated" },
    { key: "payment_success", en: "Payment Successful", es: "Pago Exitoso", fr: "Paiement Réussi", status: "translated" },
    { key: "error_message", en: "An error occurred", es: "Ocurrió un error", fr: "Une erreur s'est produite", status: "translated" }
]

export default function LocalizationPage() {
    const [selectedLanguage, setSelectedLanguage] = useState("all")
    const [selectedStatus, setSelectedStatus] = useState("all")

    const filteredLanguages = mockLanguages.filter(lang => {
        if (selectedStatus !== "all" && lang.status !== selectedStatus) return false
        return true
    })

    return (
        <AdminLayout>
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Localization & Translations</h1>
                    <p className="text-gray-600">Manage multi-language content and translations</p>
                </div>

                {/* Localization Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Supported Languages</CardTitle>
                            <Globe className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">6</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +2 this year
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Total Keys</CardTitle>
                            <Languages className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,250</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                +50 this month
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Complete Languages</CardTitle>
                            <CheckCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">2</div>
                            <div className="flex items-center text-xs text-green-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                English & Spanish
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">Pending Translations</CardTitle>
                            <AlertCircle className="h-4 w-4 text-muted-foreground" />
                        </CardHeader>
                        <CardContent>
                            <div className="text-2xl font-bold">1,420</div>
                            <div className="flex items-center text-xs text-orange-600">
                                <TrendingUp className="h-3 w-3 mr-1" />
                                Across 4 languages
                            </div>
                        </CardContent>
                    </Card>
                </div>

                {/* Language Management */}
                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>Language Management</CardTitle>
                            <div className="flex space-x-2">
                                <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                                    <SelectTrigger className="w-32">
                                        <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All Status</SelectItem>
                                        <SelectItem value="complete">Complete</SelectItem>
                                        <SelectItem value="in_progress">In Progress</SelectItem>
                                        <SelectItem value="pending">Pending</SelectItem>
                                    </SelectContent>
                                </Select>
                                <Button>
                                    <Globe className="h-4 w-4 mr-2" />
                                    Add Language
                                </Button>
                            </div>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Language</TableHead>
                                    <TableHead>Code</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Progress</TableHead>
                                    <TableHead>Translated Keys</TableHead>
                                    <TableHead>Last Updated</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredLanguages.map((language) => (
                                    <TableRow key={language.code}>
                                        <TableCell className="font-medium">{language.name}</TableCell>
                                        <TableCell>{language.code.toUpperCase()}</TableCell>
                                        <TableCell>
                                            <Badge variant={
                                                language.status === "complete" ? "default" :
                                                    language.status === "in_progress" ? "secondary" : "outline"
                                            }>
                                                {language.status.replace('_', ' ')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="w-full bg-gray-200 rounded-full h-2">
                                                <div
                                                    className="bg-blue-600 h-2 rounded-full"
                                                    style={{ width: `${(language.translatedKeys / language.totalKeys) * 100}%` }}
                                                ></div>
                                            </div>
                                            <span className="text-xs text-gray-600">
                                                {Math.round((language.translatedKeys / language.totalKeys) * 100)}%
                                            </span>
                                        </TableCell>
                                        <TableCell>{language.translatedKeys}/{language.totalKeys}</TableCell>
                                        <TableCell>{language.lastUpdated}</TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Edit</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Translate</button>
                                                <button className="text-sm text-red-600 hover:text-red-800">Remove</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Translation Keys */}
                <Card>
                    <CardHeader>
                        <CardTitle>Translation Keys</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Key</TableHead>
                                    <TableHead>English</TableHead>
                                    <TableHead>Spanish</TableHead>
                                    <TableHead>French</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {mockTranslationKeys.map((translation) => (
                                    <TableRow key={translation.key}>
                                        <TableCell className="font-medium">{translation.key}</TableCell>
                                        <TableCell>{translation.en}</TableCell>
                                        <TableCell>{translation.es}</TableCell>
                                        <TableCell>{translation.fr}</TableCell>
                                        <TableCell>
                                            <Badge variant="default">Translated</Badge>
                                        </TableCell>
                                        <TableCell>
                                            <div className="flex space-x-2">
                                                <button className="text-sm text-blue-600 hover:text-blue-800">Edit</button>
                                                <button className="text-sm text-orange-600 hover:text-orange-800">Review</button>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </CardContent>
                </Card>

                {/* Translation Tools */}
                <Card>
                    <CardHeader>
                        <CardTitle>Translation Tools</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="space-y-4">
                                <h3 className="font-semibold">Auto Translation</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        <Globe className="h-4 w-4 mr-2" />
                                        Translate Missing Keys
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        <Languages className="h-4 w-4 mr-2" />
                                        Review Auto Translations
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Export/Import</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        Export Translation Files
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        Import Translations
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-4">
                                <h3 className="font-semibold">Quality Control</h3>
                                <div className="space-y-2">
                                    <Button variant="outline" className="w-full">
                                        Check Translation Quality
                                    </Button>
                                    <Button variant="outline" className="w-full">
                                        Generate Translation Report
                                    </Button>
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Quick Actions */}
                <Card>
                    <CardHeader>
                        <CardTitle>Quick Actions</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Globe className="h-6 w-6 mx-auto mb-2" />
                                    <div>Add Language</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <Languages className="h-6 w-6 mx-auto mb-2" />
                                    <div>Translate Keys</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <CheckCircle className="h-6 w-6 mx-auto mb-2" />
                                    <div>Review Quality</div>
                                </div>
                            </Button>
                            <Button variant="outline" className="h-20">
                                <div className="text-center">
                                    <TrendingUp className="h-6 w-6 mx-auto mb-2" />
                                    <div>Export Data</div>
                                </div>
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </AdminLayout>
    )
} 