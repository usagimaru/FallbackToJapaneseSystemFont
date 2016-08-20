//
//  ViewController.swift
//  FallbackToJapaneseSystemFont
//
//  Created by M.Satori on 15.12.18.
//  Copyright © 2015 usagimaru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var label: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let text = "これは日本語文章と Roman Text の混植文章です。美しいヒラギノと San Francisco で日本語とローマ字を書きます。System Font のフォントメトリクスには独自の調整が入っています。\n\nあのイーハトーヴォの\nすきとおった風、\n夏でも底に冷たさをもつ青いそら、\nうつくしい森で飾られたモーリオ市、\n郊外のぎらぎらひかる草の波。\n祇辻飴葛蛸鯖鰯噌庖箸\n底辺直卿蝕薩化\nABCDEFGHIJKLM\nabcdefghijklm\n1234567890"
		let fontSize: CGFloat = 22.0
		
		// 適当に行間を空ける処理
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		paragraphStyle.minimumLineHeight = fontSize * 1.5
		paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight
		
//		let attributedString = systemFont(text, fontSize: fontSize, paragraphStyle: paragraphStyle)
		let attributedString = fallback(text, fontSize: fontSize, paragraphStyle: paragraphStyle)
		label.attributedText = attributedString
	}
	
	/// システムフォントで属性付き文字列を作る（通常の方法）
	func systemFont(text: String, fontSize: CGFloat, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
		let systemFont = UIFont.systemFontOfSize(fontSize)
		
		return NSMutableAttributedString(string: text, attributes: [
			NSParagraphStyleAttributeName : paragraphStyle,
			NSFontAttributeName : systemFont
			])
	}
	
	/// システムフォントに言語属性=jaで属性付き文字列を作る（どの言語でも日本語にフォールバックする）
	func fallback(text: String, fontSize: CGFloat, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
		let systemFont = UIFont.systemFontOfSize(fontSize)
		let lang = "ja"
		
		let attributedString = NSMutableAttributedString(string: text, attributes: [
			NSParagraphStyleAttributeName : paragraphStyle,
			kCTLanguageAttributeName as String : lang,
			NSFontAttributeName : systemFont
			])
		return attributedString
	}
	
	/// システムフォントのデスクリプターにヒラギノ書体のサブデスクリプターを指定してから属性付き文字列を作る（システムフォントとはメトリクスが異なるが一応日本語ヒラギノ書体として描画される）
	func cascadeWithHiraginoSans(text: String, fontSize: CGFloat, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
		// システムフォントとそのデスクリプター
		let systemFont = UIFont.systemFontOfSize(fontSize)
		//let hiraginoFont = UIFont(name: "HiraKakuProN-W3", size: fontSize)!
		//let heitiFont = UIFont(name: "Heiti TC", size: fontSize)!
		let systemFontDescriptor: UIFontDescriptor = systemFont.fontDescriptor()
		
		// ヒラギノをサブデスクリプターとして指定
		let japaneseFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute : "Hiragino Sans"])
		let newFontDescriptor = systemFontDescriptor.fontDescriptorByAddingAttributes([UIFontDescriptorCascadeListAttribute : [japaneseFontDescriptor]])
		let compositedFont = UIFont.init(descriptor: newFontDescriptor, size: 0.0)
		
		return NSMutableAttributedString(string: text, attributes: [
			NSParagraphStyleAttributeName : paragraphStyle,
			NSFontAttributeName : compositedFont
			])
	}
}

