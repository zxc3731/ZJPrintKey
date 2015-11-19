# ZJPrintKey
更加方便我们创建基于MJExtension的模型类 例如数据:
```objective-c
{
"result": 1,
"msg": "获取成功",
"data": [
{
"gcId": 36,
"bannerUrl": "",
"goodsList": [
{
"goodsId": 30,
"goodsImage": "",
"goodsName": ""
},
{
"goodsId": 32,
"goodsImage": "",
"goodsName": ""
}
],
"floorType": "1*3",
"floorName": ""
},
{
"gcId": 32,
"bannerUrl": "",
"goodsList": [
{
"goodsId": 20,
"goodsImage": "",
"goodsName": ""
}
],
"floorType": "2*2",
"floorName": ""
}
]
}
```
类中调用
```objective-c
[self zj_dictionaryToLogUrlStr:@"urlString” andKey:@"data" andKeyReplaceDictionary:nil];
```
可以打印出
```objective-c
/**********ZJPrintKey***********/
@property (copy, nonatomic) NSString *floorName;
@property (copy, nonatomic) NSString *bannerUrl;
@property (copy, nonatomic) NSString *floorType;
@property (strong, nonatomic) NSArray *goodsList;
@property (strong, nonatomic) NSNumber *gcId;
/**********ZJPrintKey***********/
```
然后复制粘贴即可！
Just for study!
