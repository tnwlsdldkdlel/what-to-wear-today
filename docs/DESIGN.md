# Design Guide: What to Wear Today?

## 1. Design Goals and Core Principles

The app's design aims for users to obtain information **as quickly and clearly as possible**, while making the data submission process **cheerful and straightforward**.

| Principle        | Description                                                                  | Application Direction                                          |
| :--------------- | :--------------------------------------------------------------------------- | :------------------------------------------------------------- |
| **Clarity**      | Minimize complexity to allow information to be grasped instantly.            | Use bold text, high contrast, and clear numbers (temperature). |
| **Locality**     | Emphasize trust by highlighting the "nearby data" aspect.                    | Prominently display location information (Area Name).          |
| **Cheerfulness** | Make the process of choosing clothes and submitting data light and positive. | Utilize **Emojis**, use a gentle color palette.                |

---

## 2. Color Palette

The colors are defined to intuitively convey weather conditions and comfort levels (Hot/Cold).

| Usage                   | Color (Hex Code)        | Description                                                      |
| :---------------------- | :---------------------- | :--------------------------------------------------------------- |
| **Primary**             | `#5C6BC0` (Calm Blue)   | Brand color, used for main buttons/icons. Conveys trust.         |
| **Background**          | `#F5F5F5` (Light Gray)  | Clean background to make information stand out.                  |
| **Accent (CTA)**        | `#FF8A65` (Warm Orange) | Used for Call-to-Action buttons like the data submission button. |
| **Comfort: Hot**        | `#EF5350` (Red)         | Used for 'Hot' feedback and high-temperature display.            |
| **Comfort: Just Right** | `#66BB6A` (Green)       | **Core recommendation color**, used for 'Just Right' feedback.   |
| **Comfort: Cold**       | `#42A5F5` (Sky Blue)    | Used for 'Cold' feedback and low-temperature display.            |

---

## 3. Typography and Text Colors

### 3.1 Text Color Definitions

Text colors are optimized for readability against the light background (`#F5F5F5`).

| Usage                 | Color (Hex Code)        | Description                                                                                                        |
| :-------------------- | :---------------------- | :----------------------------------------------------------------------------------------------------------------- |
| **Primary Text**      | `#333333` (Dark Gray)   | Used for body text, general information, and primary headings.                                                     |
| **Secondary Text**    | `#666666` (Medium Gray) | Used for supplementary text, timestamps, and descriptive footnotes.                                                |
| **On Primary/Accent** | `#FFFFFF` (White)       | Used for text placed on top of the **Primary Color** (`#5C6BC0`) or **Accent Color** (`#FF8A65`) buttons/surfaces. |

### 3.2 Typography Hierarchy

| Element                  | Size and Style   | Purpose                                              |
| :----------------------- | :--------------- | :--------------------------------------------------- |
| **Header (Key Info)**    | 24pt, Extra Bold | Current temperature, core recommendation statement.  |
| **Sub Header (Section)** | 18pt, Bold       | Area name, section titles (e.g., 'Hourly Forecast'). |
| **Body (Main Text)**     | 14pt, Regular    | General information and explanatory text.            |
| **Small Text**           | 12pt, Light      | Auxiliary information like data source or timestamp. |

---

## 4. Core UI/UX Element Guide

### 4.1 Home Screen (Recommendation View)

| Element                      | Guideline                                                                                                                                                         |
| :--------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Placement**                | The most critical information (Temp, Core Recommendation) should be placed **largest** at the top center to enable decision-making within 1 second.               |
| **Recommendation Statement** | Provide the recommendation in a **sentence format** (e.g., "In Gangnam-gu, many are wearing a Knit, Long pants, and Sneakers") for a friendly and practical feel. |

### 4.2 Data Submission Screen (Submission View)

| Element             | Guideline                                                                                                                                               |
| :------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Item Selection**  | Utilize **cute emojis** alongside text for clothing items to encourage visual engagement and faster selection.                                          |
| **Input Flow**      | Clear sequential steps: Top $\rightarrow$ Bottom $\rightarrow$ Outerwear $\rightarrow$ Shoes $\rightarrow$ Accessories $\rightarrow$ **Comfort Level**. |
| **Comfort Buttons** | 'Hot', 'Just Right', 'Cold' must be visually distinct using their defined color codes (Red, Green, Blue).                                               |

---

## 5. Icons and Imagery Guide

- **Icon Style:** Weather icons and functional icons must be **Monochromatic or Flat design** for simplicity and clarity.
- **Consistency:** Emojis used in the data submission process must maintain a consistent **cheerful character style**.
