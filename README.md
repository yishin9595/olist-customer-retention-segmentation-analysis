# Brazilian-E-Commerce-Olist-Growth-Strategy-Analysis


## 專案介紹
- **研究目的**：在營收成長受限下，透過「賣家產業」與「顧客分群」找出優先優化對象，重新分配行銷資源以提升營收
- **資料來源**：Brazilian E-Commerce Public Dataset by Olist (Kaggle)
- **工具**：BigQuery、Google Sheets、Google Slides

## 主要發現
- **產業面**：Watches、Health_beauty 貢獻主要營收；前者優先品牌招商，後者以高頻率低成本活動提高訂單，其餘產業以節慶檔期促銷為主
- **顧客面**：新客、忠誠客回收效率高但可承受 CPA 較低，適合低成本渠道；高消費沉睡、VIP 可承受較高 CPA，適合分眾再行銷喚醒與維護

---

## 分析架構

### 1. 賣家產業貢獻分析（訂單數 / AOV（平均客單價）/ 營收佔比）
- **目的**：分析高低貢獻的賣家產業
- **衡量指標**：訂單數、AOV（平均客單價）、營收佔比
- **建議行動**：高貢獻產業優先投入招商活動、低貢獻產業以最低成本維持，節慶再加碼

### 2. RFM 分群與投放優先順序（回收效率 vs 可承受 CPA）
- **目的**：決定各分群「該不該投入」與「適合什麼方式投入」
- **衡量指標**：回收比（回收效率）、可承受 CPA（以毛利上限估算）
- **建議行動**：
  - 回收高 & CPA 上限高：優先加碼
  - 回收高 & CPA 上限低：走低成本渠道
  - 回收低 & CPA 上限低：降低投入
  - 回收低 & CPA 上限高：用精準再行銷小量測試

---

## 分析結果
- **Google Slides**：[完整分析簡報](https://docs.google.com/presentation/d/1cl_TZVyfhlj-Ut31VTxw9Y7f8IICuv0aMs7t54P8LvI/edit?usp=drive_link)
- **Google Sheets**：[數據計算與視覺化圖表](https://docs.google.com/spreadsheets/d/1b7DfXcB7rkAvMXH_Hq9_lMV4ofwjJRFBLX0awKbqnas/edit?usp=drive_link)

## SQL Scripts
- [RFM 分群](https://github.com/yishin9595/Brazilian-E-Commerce-Olist-Growth-Strategy-Analysis/blob/3d97c27502eb68246c466048ff04b8ca26ef5a58/RFM%20%E5%88%86%E7%BE%A4.sql)
- [賣家產業營收、訂單、AOV](https://github.com/yishin9595/Brazilian-E-Commerce-Olist-Growth-Strategy-Analysis/blob/3d97c27502eb68246c466048ff04b8ca26ef5a58/%E8%B3%A3%E5%AE%B6%E7%94%A2%E6%A5%AD%E7%87%9F%E6%94%B6%E3%80%81%E8%A8%82%E5%96%AE%E3%80%81AOV.sql)

## 技能展現
- SQL、BigQuery、Google Sheets 視覺化
