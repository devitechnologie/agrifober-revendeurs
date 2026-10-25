/// AgrifoberRapport web app, which hosts the reseller API (`/api/v1/reseller`).
const apiBaseUrl = 'https://agrifober.vercel.app/api';
const supportedPhoneCountries = <String, int>{'MA': 212};
const defaultPhoneDialCode = 212;

/// Shown wherever the API has no value for a field the UI always renders.
const notAvailable = 'N/A';

/// Agrifober contact (+212 660-104665): "Appeler Agrifober" (tel:) and the
/// "Contactez Agrifober" link on the login screen.
const supportPhoneNumber = '+212660104665';

/// Same number for "Écrire sur WhatsApp" (wa.me wants digits only).
const supportWhatsAppNumber = '212660104665';
