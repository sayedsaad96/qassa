# Standard Operating Procedure (SOP) – Qassa (قَصّة)

## 1. Overview
**Purpose:**  
توضيح خطوات التشغيل الأساسية لتطبيق Qassa الذي يربط بين أصحاب البراندات ومصانع الملابس، وتمكين أي شخص من بدء الإنتاج بسهولة.

**Scope:**  
يشمل الإجراءات الأساسية للمستخدمين من نوع Brand و Factory ضمن MVP. أي ميزة خارج MVP (مثل الدفع، الشحن، Chat) مؤجلة للـ Phase القادمة.

---

## 2. User Roles & Responsibilities

### 2.1 Brand Owner
**Responsibilities:**  
- تسجيل حساب Brand.  
- إنشاء طلب تصنيع (Request).  
- تصفح المصانع وإرسال RFQ (Request for Quotation).  
- استلام عروض الأسعار ومقارنة الخيارات.

### 2.2 Factory Owner
**Responsibilities:**  
- تسجيل حساب Factory.  
- إعداد ملف المصنع (Profile).  
- استلام الطلبات من البراندات.  
- إرسال عروض الأسعار ومتابعة الطلبات.

---

## 3. MVP Workflow

### 3.1 Brand Flow
1. Signup باستخدام **Email & Password**.  
2. اختيار نوع الحساب: Brand.  
3. إنشاء ملف شخصي Brand Profile.  
4. إنشاء طلب تصنيع (Create Request):  
   - Required: Product Type, Quantity, Quality Level, Budget Range  
   - Optional: Upload Design, Notes  
5. تصفح المصانع (Browse Factories) مع الفلاتر: Location, MOQ, Product Type, Rating  
6. إرسال RFQ لمصنع أو أكثر.  
7. استلام عروض الأسعار (Offers) ومقارنة واختيار أفضل عرض.

### 3.2 Factory Flow
1. Signup باستخدام **Email & Password**.  
2. اختيار نوع الحساب: Factory.  
3. إعداد ملف المصنع (Factory Profile): Name, Location, Product Types, MOQ, Price Range, Images, Description  
4. استلام طلبات التصنيع (Requests).  
5. إرسال عروض الأسعار (Offers): Price, Production Time, Notes  
6. إدارة الطلبات: Pending / Accepted / Rejected.

---

## 4. Core Features – MVP

### 4.1 Authentication
- تسجيل باستخدام **Email & Password**.  
- اختيار نوع الحساب (Brand / Factory).

### 4.2 Brand Features
- Profile Management  
- Create Manufacturing Request  
- Browse Factories  
- View Factory Profiles  
- Send RFQ  
- Receive Offers

### 4.3 Factory Features
- Profile Management  
- Receive Requests  
- Send Offers  
- Manage Requests

---

## 5. Data Model (Supabase)

**Tables:**

### 5.1 Users
| Field | Type | Description |
|-------|------|------------|
| id | UUID | Primary Key |
| name | Text | Full Name |
| email | Text | Email Address |
| password_hash | Text | Hashed Password |
| role | Enum | brand / factory |

### 5.2 Factories
| Field | Type | Description |
|-------|------|------------|
| id | UUID | Primary Key |
| user_id | UUID | FK to users |
| name | Text | Factory Name |
| location | Text | Address / City |
| MOQ | Integer | Minimum Order Quantity |
| product_types | Array | Types of Products |
| rating | Float | Average Rating |

### 5.3 Requests
| Field | Type | Description |
|-------|------|------------|
| id | UUID | Primary Key |
| user_id | UUID | Brand who created request |
| product_type | Text | Product Category |
| quantity | Integer | Requested Qty |
| budget | Decimal | Budget Range |
| quality | Enum | Low / Medium / High |
| design_url | Text | Optional design file link |

### 5.4 Offers
| Field | Type | Description |
|-------|------|------------|
| id | UUID | Primary Key |
| request_id | UUID | FK to request |
| factory_id | UUID | FK to factory |
| price | Decimal | Offer Price |
| delivery_time | Date | Estimated Delivery |
| status | Enum | Pending / Accepted / Rejected |

---

## 6. Success Metrics
- عدد الطلبات اليومية  
- عدد المصانع المسجلة  
- نسبة الرد على الطلبات  
- متوسط وقت الرد  
- Conversion (طلب → اتفاق)

---

## 7. Out of Scope (MVP)
- Online Payment  
- Shipping  
- In-app Chat  
- Contracts  
- AI Matching

---

## 8. Future Enhancements

### Phase 2
- Chat System  
- Notifications  
- Save Factories

### Phase 3
- Payment System  
- Escrow  
- Logistics Integration

### Phase 4
- AI Matching  
- Smart Recommendations

---

## 9. Risk Mitigation
| Risk | Mitigation |
|------|-----------|
| عدم الثقة بين الأطراف | Verified Badge + Reviews |
| مصانع وهمية | Manual Approval قبل قبول الحساب |
| Slow response | Notifications + Ranking حسب سرعة الرد |

---

## 10. UX Principles
- أقل عدد Steps ممكن  
- Forms بسيطة جدًا  
- كل حاجة واضحة  
- No clutter

---

## 11. MVP Scope Summary
**To launch immediately:**  
- Authentication (Email & Password)  
- Profile Creation  
- Create Request  
- View Factories  
- Send Request  
- Receive Offer

---

## 12. Tech Stack
- **App:** Flutter  
- **Backend:** Supabase  
- **Storage:** Supabase Storage (Images)  
- **Notifications (future):** Firebase

---

## 13. Go-To-Market
1. جمع مصانع يدوي: 20–50 مصنع  
2. تجربة الفكرة على WhatsApp للتأكد من صحة الفكرة قبل التطوير  
3. التركيز على وجود مصانع وطلبات لضمان السيولة (Liquidity)