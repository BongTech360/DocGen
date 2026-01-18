# DVMS: Centralized Document & Visa Management System 🛂🏦🎓
DVMS is a robust, enterprise-grade platform built on Ruby on Rails. It is designed to automate and secure the document workflow between Visa Agencies, Banks, and Universities. The system specializes in generating tamper-proof, QR-verified documents including visas, financial statements, and enrollment agreements.

## 🚀 Key Modules
### 🛂 Visa Agency Portal
- **Application Workflow:** Full lifecycle management from initial intake to consulate submission.
- **Multi-Type Templates:** Dynamic generation of Student, Work, Tourist, and Medical visa forms.
- **Automated Billing:** Integrated invoicing system linked to application milestones.

### 🏦 Banking & Financial Suite
- **Proof of Funds (PoF):** Secure generation of financial solvency letters.
- **Digital Stamping Engine:** High-resolution digital stamps applied to PDFs with unique cryptographic hashes for authenticity.
- **Audit Trail:** Comprehensive logs of every document issued for regulatory compliance.

### 🎓 University Management
- **Offer Letter Automation:** Generate Letters of Acceptance (LOA) and enrollment contracts instantly.
- **Verification API:** A secure endpoint for agencies to verify student status without manual email chains.

## 🛠️ Tech Stack
- **Framework:** Ruby on Rails 7+ (utilizing Hotwire/Turbo for a reactive SPA feel).
- **Database:** PostgreSQL (Relational data integrity).
- **Authentication:** Devise (with Multi-Factor Authentication support).
- **Authorization:** Pundit (Role-Based Access Control).
- **PDF Generation:** WickedPDF or Grover (Chromium-based PDF rendering).
- **Background Jobs:** Sidekiq + Redis (for asynchronous document generation).
- **Storage:** Active Storage (Cloud-hosted encrypted document storage).

## 📁 Project Structure
```bash
├── app/
│   ├── controllers/      # Logic for Agency, Bank, and University portals
│   ├── models/           # Data schemas (VisaApplication, BankStatement, User)
│   ├── services/         # Document generation & QR code logic
│   ├── views/            # PDF templates (HTML/ERB) and UI
│   └── workers/          # Background jobs for bulk document processing
├── config/               # Database and environment configurations
├── db/                   # Migrations and schema
├── spec/                 # RSpec test suite for security and logic
└── docker/               # Containerization files
```

## ⚙️ Getting Started
### Prerequisites
- Ruby 3.2+
- PostgreSQL 14+
- Redis
- Node.js & Yarn (for asset compilation)

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/dvms-rails.git
   cd dvms-rails
   ```

2. **Install Dependencies:**
   ```bash
   bundle install
   yarn install
   ```

3. **Database Setup:**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start the Application:**
   ```bash
   bin/dev
   ```
   The app will be available at http://localhost:3000.

## 🔒 Security & Verification
This system implements Digital Fingerprinting. Every generated PDF is hashed, and that hash is stored in the database. When a QR code is scanned, the system compares the physical document's hash against the record to ensure zero tampering.

## 📄 License
This project is licensed under the MIT License.
