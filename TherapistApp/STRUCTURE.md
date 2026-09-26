ezyhomecare/
│
├── app/
│   ├── pages/
│   │
│   │   ├── index.vue
│   │   │
│   │   ├── auth/
│   │   │   ├── login.vue
│   │   │   ├── register.vue
│   │   │   └── forgot-password.vue
│   │   │
│   │   ├── customer/
│   │   │   ├── index.vue
│   │   │   ├── services/
│   │   │   ├── therapists/
│   │   │   ├── booking/
│   │   │   ├── payment/
│   │   │   ├── bookings/
│   │   │   └── profile/
│   │   │
│   │   ├── therapist/
│   │   │   ├── index.vue
│   │   │   ├── bookings/
│   │   │   ├── schedule.vue
│   │   │   ├── navigation/
│   │   │   ├── income.vue
│   │   │   └── profile.vue
│   │   │
│   │   └── admin/
│   │       ├── index.vue
│   │       ├── services/
│   │       ├── therapists/
│   │       ├── customers/
│   │       ├── bookings/
│   │       ├── payments/
│   │       └── reports/
│   │
│   ├── layouts/
│   │   ├── default.vue
│   │   ├── customer.vue
│   │   ├── therapist.vue
│   │   └── admin.vue
│   │
│   ├── middleware/
│   │   ├── auth.ts
│   │   ├── customer.ts
│   │   ├── therapist.ts
│   │   └── admin.ts
│   │
│   ├── components/
│   │   ├── customer/
│   │   ├── therapist/
│   │   ├── admin/
│   │   └── shared/
│   │
│   └── composables/
│       ├── useAuth.ts
│       ├── useBooking.ts
│       ├── useService.ts
│       └── useTherapist.ts
│
├── server/
│   ├── api/
│   │   ├── auth/
│   │   │   ├── login.post.ts
│   │   │   ├── register.post.ts
│   │   │   ├── logout.post.ts
│   │   │   └── me.get.ts
│   │   │
│   │   ├── customer/
│   │   ├── therapist/
│   │   ├── admin/
│   │   ├── services/
│   │   ├── bookings/
│   │   └── payments/
│   │
│   ├── middleware/
│   └── utils/
│       ├── auth.ts
│       └── db.ts
│
├── shared/
│   ├── types/
│   │   ├── auth.ts
│   │   ├── booking.ts
│   │   └── user.ts
│   └── constants/
│
└── public/