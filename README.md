### 專案介紹
針對電商資料進行分析，透過數據洞察，歸納出能提升營收的具體的行銷策略

### 研究目的
從以下三個面向進行分析：
*   **RFM 分析**：針對不同族群來建議後續行動
*   **顧客滿意度分析**：分析物流表現對評分的影響
*   **商品類別回購率**：找出具備高黏著度的潛力品類

### 資料來源
*   Brazilian E-Commerce（Kaggle 公開數據）

### 研究工具
*   **BigQuery**：進行 SQL 資料查詢
*   **Google Sheets、Excel**：將分析結果視覺化
*   **Google Slides**：整合數據洞察，製作分析簡報，提出具體的行銷建議方案

### 主要發現
1.  **回購關鍵期**：首購後 **30 天**為回購關鍵期，約 **50.8%** 的回購發生在此期間
2.  **物流影響力**：運送延遲率與顧客滿意度呈負相關；**São Gonçalo** 為延遲比例最高的城市，嚴重影響顧客體驗
3.  **潛力品類**：**Eletrodomésticos (小型家電)** 的回購率高達 **7%**，顯示該品類具有良好的客戶黏著度

### 分析結果
*   **Google Slide 簡報**：[完整分析簡報](https://docs.google.com/presentation/d/1cl_TZVyfhlj-Ut31VTxw9Y7f8IICuv0aMs7t54P8LvI/edit?usp=drive_link)
*   **SQL Scripts**：
- [RFM 分群](sql%20script/RFM%20分群.sql)
- [回購天數分析](sql%20script/回購天數分析.sql)
- [產品回購率](sql%20script/產品回購率.sql)
- [顧客滿意度＆運送延遲分析](sql%20script/顧客滿意度＆運送延遲分析.sql)
