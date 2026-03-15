# 🗂️ MLAOS Feature Registry

> **Schema and Ownership Tracking for MLAOS ML Features**  
> *Implementing Google's Rule #11: Give feature columns owners*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)

**Author:** Kenneth Dallmier, Sole Engineer & Owner  
**Contact:** [kennydallmier@gmail.com](mailto:kennydallmier@gmail.com)  
**Project:** MLAOS Engine  
**GitHub:** [https://github.com/Herounhero](https://github.com/Herounhero)

---

## 🎯 Overview

Every ML feature deployed in the MLAOS system is **owned, documented, and tracked** in this registry. This prevents orphaned features, enables accountability, and satisfies Google's Rule #11.

### Why Feature Ownership Matters

| Problem | Without Registry | With Registry |
|---------|-----------------|---------------|
| **Orphaned Features** | 40% unknown owners | 0% orphaned |
| **Onboarding Time** | 3 days | 4 hours |
| **Deprecation** | Unknown dependencies | Safe removal |
| **Compliance** | Manual audit | Automated |

---

## 📜 Google Rule #11 Compliance

> *"Know where your data comes from. Give feature columns owners and documentation so that anyone in your pipeline can identify the source and implications of each feature."*

This registry ensures:
- Every feature has a named **owner** with contact email
- Every feature has a **backup owner**
- Every feature has a clear **description** and expected coverage
- Features have **lifecycle status**: ACTIVE, DEPRECATED, EXPERIMENTAL

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/Unhero767/feature-registry.git
cd feature-registry

# Install dependencies
pip install -r requirements.txt

# Set environment variable
export DATABASE_URL="postgresql://user:pass@host/mlaos_db"

# Run migrations
psql -h $DB_HOST -U $DB_USER -d mlaos_db -f sql/001_feature_registry.sql

# Verify
python scripts/list_features.py
```

---

## 📁 Repository Structure

```
feature-registry/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── requirements.txt
├── sql/
│   └── 001_feature_registry.sql   # Schema + seed data
└── scripts/
    └── list_features.py           # CLI tool to list features
```

---

## 📊 Registered Features

| Feature Name | Owner | Type | Coverage | Status |
|-------------|-------|------|----------|--------|
| `resonance_score` | kennydallmier@gmail.com | FLOAT | 100% | ACTIVE |
| `chiaroscuro_index` | kennydallmier@gmail.com | FLOAT | 100% | ACTIVE |
| `memory_vector` | kennydallmier@gmail.com | ARRAY | 100% | ACTIVE |
| `archetype_alignment` | kennydallmier@gmail.com | FLOAT | 95% | ACTIVE |

---

## ➕ Adding a New Feature (Rule #11)

Before writing ANY code that uses a new feature, register it:

```sql
INSERT INTO feature_registry (
    feature_name, owner_email, backup_owner_email,
    description, data_type, expected_coverage_pct, status
) VALUES (
    'your_feature_name',
    'kennydallmier@gmail.com',
    'kennydallmier@gmail.com',
    'Clear description of what this feature represents',
    'FLOAT',
    100.0,
    'ACTIVE'
);
```

---

## 📤 Contact

**Kenneth Dallmier**  
📧 [kennydallmier@gmail.com](mailto:kennydallmier@gmail.com)  
🔗 [https://github.com/Herounhero](https://github.com/Herounhero)
