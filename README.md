# DocGen

An enterprise-grade **Ruby on Rails** platform for visa agencies, banks, and universities to automate the generation and management of visas, bank documents, agreements, and invoices with integrated digital stamping and QR-based verification.

## Features

- **Multi-Document Support**: Generate and manage visas, bank documents, agreements, and invoices
- **Digital Stamping**: Secure digital stamps with timestamps and verification hashes
- **QR Code Verification**: QR code-based document verification system
- **Multi-Tenant Architecture**: Support for multiple organizations (agencies, banks, universities)
- **User Authentication**: Secure authentication using Devise
- **PDF Generation**: Professional PDF documents with Prawn
- **Document Management**: Full CRUD operations for documents

## Requirements

- Ruby 3.2.2 or higher
- Rails 8.1.1
- PostgreSQL
- Node.js (for asset pipeline)

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/BongTech360/DocGen.git
   cd DocGen
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   # Create and migrate the database
   rails db:create
   rails db:migrate
   ```

4. **Set up environment variables**
   
   Create a `.env` file in the root directory (optional, for production):
   ```env
   DATABASE_URL=postgresql://user:password@localhost/docgen_development
   SECRET_KEY_BASE=your_secret_key_base
   ```

5. **Start the Rails server**
   ```bash
   rails server
   ```

   The application will be available at `http://localhost:3000`

## Usage

### Creating an Organization

1. Sign up for a new account
2. Create an organization (Visa Agency, Bank, or University)
3. Set up your organization's subdomain

### Creating Documents

1. Navigate to Documents
2. Click "New Document"
3. Select document type (Visa, Bank Document, Agreement, or Invoice)
4. Fill in the document metadata as JSON:
   - **Visas**: `{"passport_number": "123456", "visa_type": "Tourist", "country": "USA", "issue_date": "2024-01-01", "expiry_date": "2024-12-31", "duration": "90 days", "holder_name": "John Doe"}`
   - **Bank Documents**: `{"account_number": "123456789", "transaction_id": "TXN001", "amount": "1000.00", "currency": "USD", "date": "2024-01-01", "description": "Payment", "balance": "5000.00"}`
   - **Agreements**: `{"party1": "Company A", "party2": "Company B", "effective_date": "2024-01-01", "expiry_date": "2024-12-31", "terms": "Terms and conditions..."}`
   - **Invoices**: `{"invoice_number": "INV001", "date": "2024-01-01", "bill_to": "Customer Name", "items": [{"description": "Item 1", "quantity": 2, "price": "100.00", "total": "200.00"}], "subtotal": "200.00", "tax": "20.00", "total": "220.00"}`

### Generating PDFs

1. View a document
2. Click "Generate PDF" to create a PDF with:
   - Document content
   - Digital stamp
   - QR code for verification

### Verifying Documents

1. Navigate to a document's verify page
2. Scan the QR code or use the verification URL
3. Click "Verify Document" to mark it as verified

## Project Structure

```
DocGen/
├── app/
│   ├── controllers/        # Application controllers
│   ├── models/             # ActiveRecord models
│   ├── services/           # Business logic services
│   │   ├── document_generator_service.rb
│   │   └── qr_verification_service.rb
│   ├── views/              # ERB templates
│   └── assets/             # CSS and JavaScript
├── config/
│   ├── routes.rb           # Application routes
│   └── database.yml        # Database configuration
├── db/
│   └── migrate/            # Database migrations
└── README.md
```

## Key Technologies

- **Rails 8.1.1**: Web framework
- **PostgreSQL**: Database
- **Devise**: Authentication
- **Prawn**: PDF generation
- **RQRCode**: QR code generation
- **ChunkyPNG**: Image processing for digital stamps

## Development

### Running Tests

```bash
rails test
```

### Database Migrations

```bash
# Create a new migration
rails generate migration MigrationName

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback
```

### Console

```bash
rails console
```

## API Endpoints

The application includes API endpoints under `/api/v1/`:

- `GET /api/v1/documents` - List documents
- `GET /api/v1/documents/:id` - Show document
- `POST /api/v1/documents` - Create document
- `PUT /api/v1/documents/:id` - Update document
- `GET /api/v1/documents/:id/generate_pdf` - Generate PDF
- `GET /api/v1/documents/:id/verify` - Verify document

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@docgen.com or open an issue in the repository.
