;; Decentralized File Metadata Contract
;; Stores basic metadata for files in a decentralized way

;; Error codes
(define-constant err-file-exists (err u100))
(define-constant err-invalid-data (err u101))
(define-constant err-file-not-found (err u102))

;; Map to store file metadata
;; file-id => { name: string, hash: string }
(define-map file-metadata
  uint
  {
    name: (string-ascii 64),
    hash: (string-ascii 128)
  }
)

;; Function 1: Add new file metadata
(define-public (add-file (file-id uint) (name (string-ascii 64)) (hash (string-ascii 128)))
  (begin
    ;; Check valid data
    (asserts! (> file-id u0) err-invalid-data)
    (asserts! (> (len name) u0) err-invalid-data)
    (asserts! (> (len hash) u0) err-invalid-data)

    ;; Ensure file ID not already stored
    (asserts! (is-none (map-get? file-metadata file-id)) err-file-exists)

    ;; Store metadata
    (map-set file-metadata file-id { name: name, hash: hash })

    (ok true)
  )
)

;; Function 2: Get file metadata
(define-read-only (get-file (file-id uint))
  (match (map-get? file-metadata file-id)
    file-data (ok file-data)
    err-file-not-found
  )
)
