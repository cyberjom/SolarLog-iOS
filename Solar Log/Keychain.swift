import Security

public class Keychain {
	public class func save(str: String?, forKey: String) -> Bool {
		if str == nil {
			return false
		}

		let dataFromString: NSData = str!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		let query = [
			kSecClass as String: kSecClassGenericPassword as String,
			kSecAttrAccount as String: forKey,
			kSecValueData as String: dataFromString
		]

		SecItemDelete(query as CFDictionaryRef)

		let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)

		return status == noErr
	}

	public class func load(key: String) -> String? {
		let query = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecReturnData as String: kCFBooleanTrue,
			kSecMatchLimit as String: kSecMatchLimitOne
		]

		var dataTypeRef: Unmanaged<AnyObject>?

		let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
		let opaque = dataTypeRef?.toOpaque()

		if let op = opaque? {
			let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
			return NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
		}
		return nil
	}

	public class func delete(key: String) -> Bool {
		let query = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key
		]

		let status: OSStatus = SecItemDelete(query as CFDictionaryRef)

		return status == noErr
	}

	public class func clear() -> Bool {
		let query = [
			kSecClass as String: kSecClassGenericPassword
		]

		let status: OSStatus = SecItemDelete(query as CFDictionaryRef)

		return status == noErr
	}
}