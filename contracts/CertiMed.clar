MedicalDevice Smart Contract
;; Enables transparent tracking of medical device lifecycle and certifications

;; title: Certimed
;; version:
;; summary:
;; description:
(define-trait medical-device-tracking-trait
  (
    (register-device (uint uint) (response bool uint))
    (update-device-status (uint uint) (response bool uint))
    (get-device-history (uint) (response (list 10 {status: uint, timestamp: uint}) uint))
    (add-certification (uint uint principal) (response bool uint))
    (verify-certification (uint uint) (response bool uint))
  )
)

;; traits
;;
;; Define device status constants
(define-constant DEVICE_STATUS_MANUFACTURED u1)
(define-constant DEVICE_STATUS_TESTING u2)
(define-constant DEVICE_STATUS_DEPLOYED u3)
(define-constant DEVICE_STATUS_MAINTAINED u4)

;; token definitions
;;
;; Define certification type constants
(define-constant CERT_TYPE_FDA u1)
(define-constant CERT_TYPE_CE u2)
(define-constant CERT_TYPE_ISO u3)
(define-constant CERT_TYPE_SAFETY u4)

;; constants
;;
;; Error constants
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_INVALID_DEVICE (err u2))
(define-constant ERR_STATUS_UPDATE_FAILED (err u3))
(define-constant ERR_INVALID_STATUS (err u4))
(define-constant ERR_INVALID_CERTIFICATION (err u5))
(define-constant ERR_CERTIFICATION_EXISTS (err u6))

;; data vars
;;
;; Contract owner
(define-data-var contract-owner principal tx-sender)

;; data maps
;;
;; Current timestamp counter
(define-data-var timestamp-counter uint u0)

;; public functions
;;
;; Device tracking map
(define-map device-details 
  {device-id: uint} 
  {
    owner: principal,
    current-status: uint,
    history: (list 10 {status: uint, timestamp: uint})
  }
)

;; read only functions
;;
;; Certification tracking map
(define-map device-certifications
  {device-id: uint, cert-type: uint}
  {
    issuer: principal,
    timestamp: uint,
    valid: bool
  }
)

;; private functions
;;
;; Approved regulatory bodies
(define-map regulatory-bodies
  {authority: principal, cert-type: uint}
  {approved: bool}
)

;; Get current timestamp and increment counter
(define-private (get-current-timestamp)
  (begin
    (var-set timestamp-counter (+ (var-get timestamp-counter) u1))
    (var-get timestamp-counter)
  )
)

;; Only contract owner can perform certain actions
(define-read-only (is-contract-owner (sender principal))
  (is-eq sender (var-get contract-owner))
)

;; Validate status
(define-private (is-valid-status (status uint))
  (or 
    (is-eq status DEVICE_STATUS_MANUFACTURED)
    (is-eq status DEVICE_STATUS_TESTING)
    (is-eq status DEVICE_STATUS_DEPLOYED)
    (is-eq status DEVICE_STATUS_MAINTAINED)
  )
)

;; Validate certification type
(define-private (is-valid-certification-type (cert-type uint))
  (or
    (is-eq cert-type CERT_TYPE_FDA)
    (is-eq cert-type CERT_TYPE_CE)
    (is-eq cert-type CERT_TYPE_ISO)
    (is-eq cert-type CERT_TYPE_SAFETY)
  )
)

;; Validate device ID
(define-private (is-valid-device-id (device-id uint))
  (and (> device-id u0) (<= device-id u1000000))
)

;; Check if sender is approved regulatory body
(define-private (is-regulatory-body (authority principal) (cert-type uint))
  (default-to 
    false
    (get approved (map-get? regulatory-bodies {authority: authority, cert-type: cert-type}))
  )
)

;; Register a new device
(define-public (register-device (device-id uint) (initial-status uint))
  (begin
    (asserts! (is-valid-device-id device-id) ERR_INVALID_DEVICE)
    (asserts! (is-valid-status initial-status) ERR_INVALID_STATUS)
    (asserts! (or (is-contract-owner tx-sender) (is-eq initial-status DEVICE_STATUS_MANUFACTURED)) ERR_UNAUTHORIZED)

    (map-set device-details 
      {device-id: device-id}
      {
        owner: tx-sender,
        current-status: initial-status,
        history: (list {status: initial-status, timestamp: (get-current-timestamp)})
      }
    )
    (ok true)
  )
)
