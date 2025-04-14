

# 📟 Certimed Smart Contract – Medical Device Lifecycle & Certification Tracker

> **Secure. Transparent. Verifiable.**
>
> A Clarity smart contract for tracking medical devices' lifecycle events and regulatory certifications on the Stacks blockchain.

---

## 📌 Overview

**MedDev** is a smart contract written in [Clarity](https://docs.stacks.co/docs/write-smart-contracts/clarity-language) that enables **transparent tracking** of medical devices from manufacturing to maintenance. It also facilitates **auditable certification management** by approved regulatory authorities such as FDA, CE, and ISO.

The contract enforces strict validation rules, ensures only authorized entities can register or certify devices, and offers complete visibility into the device lifecycle history and certifications.

---

## 🚀 Features

- ✅ **Register new medical devices**
- 🔄 **Update lifecycle status** (manufactured, testing, deployed, maintained)
- 📜 **Track historical status changes** with timestamps
- 🛡️ **Add or verify certifications** (e.g., FDA, CE, ISO)
- 🚫 **Revoke certifications** by authority or contract owner
- 🏛️ **Approve regulatory bodies** to certify devices
- 🔍 **Verify device certification validity**
- 🧾 **Fetch certification and lifecycle history**

---

## 💾 Contract Interface (Public Functions)

### Device Management
- `register-device (device-id uint) (initial-status uint)`
- `update-device-status (device-id uint) (new-status uint)`
- `get-device-status (device-id uint)`
- `get-device-history (device-id uint)`

### Certification Management
- `add-certification (device-id uint) (cert-type uint)`
- `verify-certification (device-id uint) (cert-type uint)`
- `get-certification-details (device-id uint) (cert-type uint)`
- `revoke-certification (device-id uint) (cert-type uint)`

### Regulatory Authority Management
- `add-regulatory-body (authority principal) (cert-type uint)`

---

## 📖 Constants

### Status Codes
| Status Name     | Code |
|-----------------|------|
| Manufactured    | `u1` |
| Testing         | `u2` |
| Deployed        | `u3` |
| Maintained      | `u4` |

### Certification Types
| Certification | Code |
|---------------|------|
| FDA           | `u1` |
| CE            | `u2` |
| ISO           | `u3` |
| Safety        | `u4` |

---

## 🧠 Validation Rules

- Device IDs must be within range (`1` to `1,000,000`)
- Only approved regulatory bodies can certify devices
- Certification types and status codes are strictly validated
- Certification cannot be added more than once per type
- Only the contract owner or certification issuer can revoke a certification

---

## ⚠️ Error Codes

| Code     | Meaning                         |
|----------|---------------------------------|
| `u1`     | Unauthorized action             |
| `u2`     | Invalid device ID               |
| `u3`     | Status update failed            |
| `u4`     | Invalid device status           |
| `u5`     | Invalid certification type      |
| `u6`     | Certification already exists    |

---

## 🔐 Access Control

- **Contract Owner**: Has authority to add regulatory bodies and register devices under any status
- **Device Owners**: Can update their own device status
- **Regulatory Authorities**: Can issue and revoke certifications

---

## 🛠️ Usage Example

```lisp
;; Register a new device as "Manufactured"
(register-device u1001 DEVICE_STATUS_MANUFACTURED)

;; Update device status to "Deployed"
(update-device-status u1001 DEVICE_STATUS_DEPLOYED)

;; Add a CE certification
(add-certification u1001 CERT_TYPE_CE)

;; Verify the CE certification
(verify-certification u1001 CERT_TYPE_CE)
```

---

