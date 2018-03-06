Edo.apply(Edo.controls.DatePicker.prototype, {
    weeks: ['日','月','火','水','木','金','土'],
    yearFormat: 'Y年',
    monthFormat: 'm月',
    todayText: '今日',
    clearText: '清除'
});
Edo.apply(Edo.MessageBox, {
    buttonText : {
        ok : "確定",
        cancel : "キャンセル",   
        yes : "はい",
        no : "いいえ"
    },
    saveText: '保存中...'
});

if(Edo.data.DataGantt){
    Edo.apply(Edo.data.DataGantt, {
        PredecessorLinkType: [
            {ID: 0, Name: '完成-完成(FF)', EName: 'FF', Date: ['Finish', 'Finish']},
            {ID: 1, Name: '完成-開始(FS)', EName: 'FS', Date: ['Finish', 'Start']},
            {ID: 2, Name: '開始-完成(SF)', EName: 'SF', Date: ['Start', 'Finish']},
            {ID: 3, Name: '開始-開始(SS)', EName: 'SS', Date: ['Start', 'Start']}
        ],
        PredecessorLinkTypeMap: {
            FF: 0,
            FS: 1,
            SF: 2,
            SS: 3
        },
        dontUpgrade: '選択された任務はトップレベルになっているので、レベルアップできません。',
        dontDowngrade: 'レベルダウンできません。'
    });
}
if(Edo.lists.Gantt){
    Edo.apply(Edo.lists.Gantt, {
        yearText: '年',
        monthText: '月',
        weekText: '週',
        dayText: '日',
        hourText: '時',
        
        scrollDateFormat: 'Y-m-d 曜日l',
        
        No: '標記：',
        name: '名称：',   
        
        summaryText: '概要',
        milestoneText: '道標',
        criticalText: 'ポイント',
        taskText: '任務',
        baselineText: '比較基準',
        percentCompleteText: '進度',
        
        startText: '開始日期',
        finishText: '終了日期',
        tipDateFormat: 'Y年m月d日 H時',//i分
        
        linktaskText: '任務リンク',
        delaytimeText: '延時時間',
        fromText: 'から',
        toText: 'まで',        
        
        weekFormat: 'Y-m-d 曜日l',
        monthFormat: 'Y年m月',
        quarterFormat: 'Y年m月 - ',
        yearFormat: 'Y年',
        
        quarterformat2: '{0}年 第{1}季度',
        monthFormat2: 'Y年 - m月'
    });
    Edo.apply(Edo.lists.Gantt.prototype, {
        weeks: ['日','月','火','水','木','金','土']
    });
}
