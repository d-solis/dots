/**
* @name Uncompressed Images
* @author Knew
* @description Discord's solution to previewing images is awful so by changing 'media.discordapp.net' links to 'cdn.discordapp.com' links, we will no longer have blurry images (especially with JPEG and WebP and other lossy formats).
* @version 3.15
* @authorId 332116671294734336
* @authorLink https://github.com/Knewest
* @invite NqqqzajfK4
* @website https://twitter.com/KnewestLSEP
* @source https://github.com/Knewest/uncompressed-discord-images
* @updateUrl https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js
*/

	function debounce(func, wait) {
		let timeout;
		return function(...args) {
			const context = this;
			clearTimeout(timeout);
			timeout = setTimeout(() => func.apply(context, args), wait);
		};
	}

module.exports = class UncompressedImages {
		constructor() {
			this.observer = null;
			this.resizeListener = null;
			this.animationFrame = null;
		}

start() {

	const config = {
		attributes: true,
		childList: true,
		subtree: true,
		attributeFilter: ['src'],
	};

	const localObserver = new MutationObserver(callback);

	function centerImageBecauseRegularCSSWillNot() {
		const updateImagePositions = document.querySelectorAll('.imageContainer-10XenG .lazyImg-ewiNCh.processed-image.processed-grid-layout');

		updateImagePositions.forEach((image) => {
			const container = image.closest('.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-grid-layout');
			if (container && image) {
				const containerHeight = container.clientHeight;
				const imageHeight = image.clientHeight;
				const translateY = (containerHeight - imageHeight) / 2;
				image.style.transform = `translateY(${translateY}px)`;
			}
		});
	}

	function enhanceAvatarQuality() {
		const avatarURLs = document.querySelectorAll(
		'img.avatar-2e8lTP[src^="https://cdn.discordapp.com/avatars"]:not(.processed-avatar), img.avatar-31d8He[src^="https://cdn.discordapp.com/avatars"]:not(.processed-avatar)'
		);
		avatarURLs.forEach((image) => {
			let newSrc = image.src.replace(/\?size=\d*/, '');
			if (!newSrc.includes('?quality=lossless')) {
				newSrc += '?quality=lossless';
			}
			image.src = newSrc;
			image.classList.add('processed-avatar');
		});
	}
	
	function enhanceIconQuality() {
		const iconURLs = document.querySelectorAll(
		'img.icon-3AqZ2e[src^="https://cdn.discordapp.com/icons/"]:not(.processed-icon)'
		);
		iconURLs.forEach((image) => {
			let newSrc = image.src.replace(/\?size=\d*/, '');
			if (!newSrc.includes('?quality=lossless')) {
				newSrc += '?quality=lossless';
			}
			image.src = newSrc;
			image.classList.add('processed-icon');
		});
	}

	function adjustMaxWidthBasedOnCurrentWidth() {
		const imgElements = Array.from(document.querySelectorAll(".imageWrapper-oMkQl4.embedWrapper-1MtIDg.lazyImg-ewiNCh.attachmentContentItem-UKeiCx.processed-single-layout"));

			function processNextImage(index) {
				if (index >= imgElements.length) {
					return;
				}

			const imgElement = imgElements[index];
			if (!imgElement.classList.contains("max-width-adjusted")) {
				const style = window.getComputedStyle(imgElement);
				let currentWidth = style.getPropertyValue('width');
				if (currentWidth === "0px") currentWidth = "auto";	
				imgElement.style.maxWidth = currentWidth;
				imgElement.classList.add("max-width-adjusted");
				/** console.log(`Adjusted max-width for image to ${currentWidth}`); **/
			}
			setTimeout(() => processNextImage(index + 1), 5);
			}
		processNextImage(0);
	}

	const SELECTOR_IMG_SRC = '.zoomLens-uOK8xV img[src^="https://media.discordapp.net/attachments"]:not(.processed-image), .layerContainer-2lfOPe img[src^="https://media.discordapp.net/attachments"]:not(.processed-image), .imageContainer-10XenG img[src^="https://media.discordapp.net/attachments"]:not(.processed-image)';

	function convertMediaToCDN() {
		const mediaURLs = document.querySelectorAll(SELECTOR_IMG_SRC);
		mediaURLs.forEach((image) => {
			if (!image.classList.contains('gif-2kTiNB')) {
			image.src = image.src.replace(
				'https://media.discordapp.net/attachments',
				'https://cdn.discordapp.com/attachments'
			);
			image.classList.add('processed-image');
			}
		});
	}

	function replaceURLs() {
		const messages = document.querySelectorAll('.container-2sjPya');
			messages.forEach((message) => {
			const images = message.querySelectorAll('.imageDetails-1t6Zms');
				if (images.length === 1) {
					const image = images[0];
					image.style.display = 'inline-table';
					image.style.transform = 'translateX(5px) translateY(-0px)';
					image.style.lineHeight = 'unset';
					
					const parent = image.closest('.imageContent-3Av-9c.embedWrapper-1MtIDg.attachmentContentContainer-3WAhvQ.attachmentContentItem-UKeiCx');
		if (parent) {
			parent.appendChild(image);
		}
		} else if (images.length > 1) {
				images.forEach((image) => {
					image.style.display = 'none';
				});
		}
	});

	const mediaURLs = document.querySelectorAll(SELECTOR_IMG_SRC);
		let index = 0;
		function processImage() {
			const image = mediaURLs[index];
			if (image && !image.src.includes('.gif')) {
				const newSrc = image.src.replace(
					'https://media.discordapp.net/attachments',
					'https://cdn.discordapp.com/attachments'
				);
	const offscreenImage = new Image();
	offscreenImage.src = newSrc;
	offscreenImage.onload = function () {
			try {
			const aspectRatio = offscreenImage.naturalWidth / offscreenImage.naturalHeight;
			const maxWidth = image.closest('.imageWrapper-oMkQl4').clientWidth;
			const maxHeight = image.closest('.imageWrapper-oMkQl4').clientHeight;
			let width = offscreenImage.naturalWidth;
			let height = offscreenImage.naturalHeight;
			if (width > maxWidth) {
				width = maxWidth;
				height = width / aspectRatio;
			}
			if (height > maxHeight) {
				height = maxHeight;
				width = height * aspectRatio;
			}
			image.src = newSrc;
			image.classList.add('processed-image');
			image.style.width = `${width}px`;
			} finally {
			index++;
			if (index < mediaURLs.length && !image.src.includes('.gif')) {
				this.animationFrame = requestAnimationFrame(processImage);
			}
		};
	}
	}
		this.animationFrame = requestAnimationFrame(processImage);
	}

	let images = document.querySelectorAll('.imageContainer-10XenG .lazyImg-ewiNCh.processed-image.processed-single-layout');
	images.forEach((image) => {
		image.addEventListener('load', function () {
		const classElement = image.closest('.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-single-layout');
		if (classElement && image.naturalWidth > image.naturalHeight) {
			classElement.classList.add('auto-width');
		}
		});
	});
	}

	this.resizeListener = window.addEventListener('resize', debounce(centerImageBecauseRegularCSSWillNot, 100));

	function processImageSrc() {
	convertMediaToCDN();
	replaceURLs();
	checkForGridLayout();
	centerImageBecauseRegularCSSWillNot();
	setTimeout(adjustMaxWidthBasedOnCurrentWidth, 3000);
	}

	function callback(mutationsList, observer) {
		for (const mutation of mutationsList) {
			if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
				const addedImages = Array.from(mutation.addedNodes).flatMap((node) =>
				node.querySelectorAll
				? Array.from(node.querySelectorAll(SELECTOR_IMG_SRC))
				: []
			);

			addedImages.forEach((image) => {
				if (!image.src.includes('.gif')) {
				setImmediate(processImageSrc);
				}
			});
			} else if (mutation.type === 'attributes' && mutation.attributeName === 'src') {
			if (!mutation.target.src.includes('.gif')) {
				processImageSrc();
				enhanceAvatarQuality();
				enhanceIconQuality();
			}
			}
		}
	}

	function checkForGridLayout() {
	const messages = document.querySelectorAll('.container-2sjPya');
	messages.forEach((message) => {
		const elements = message.querySelectorAll('.lazyImg-ewiNCh, .imageContainer-10XenG, .lazyImgContainer-3k3gRy, .imageWrapper-oMkQl4, .imageContent-3Av-9c');
		const imageElements = message.querySelectorAll('.lazyImg-ewiNCh');
		if (imageElements.length > 1) {
		elements.forEach((element) => {
			element.classList.add('processed-grid-layout');
		});
		} else if (imageElements.length === 1) {
		elements.forEach((element) => {
			element.classList.add('processed-single-layout');
		});
		}
	});
	}

	function createUncompressedImagesCSSStyle() {
	const style = document.createElement('style');
	style.textContent = `

		.mediaAttachmentsContainer-1WGRWy {
			width: initial !important;
		}	
	
		.auto-width {
			width: auto !important;
			height: auto !important;
			max-width: 550px !important;
		}		
		
		.auto-width img {
			max-height: 350px !important;
		}
	
		.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-single-layout {
			margin: initial !important;
		}
		
		.clickableWrapper-2WTAkL {
			height: none !important;
		}
		
		.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-grid-layout {
			display: -webkit-box !important;
		}
		
		.imageContent-3Av-9c.embedWrapper-1MtIDg.attachmentContentContainer-3WAhvQ.attachmentContentItem-UKeiCx.processed-single-layout {
			height: auto !important;
			width: auto !important;
			max-width: 550px !important;		
		}

		.imageWrapper-oMkQl4.embedWrapper-1MtIDg.lazyImg-ewiNCh.attachmentContentItem-UKeiCx.processed-single-layout {
			width: auto !important;
		}
			
		.lazyImg-ewiNCh.processed-image.processed-grid-layout {
			aspect-ratio: unset !important;
			display: grid !important;
			width: auto !important;
			height: auto !important;
			object-fit: cover !important;
		}
		
		.lazyImg-ewiNCh processed-image processed-single-layout {
			max-width: 550px !important;
		}	
	
		.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-grid-layout {
			max-width: 100% !important;
		}
		
		.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-single-layout {
			height: 100% !important;
		}
		
		.cursorPointer-B3uwDA {
			transform: translateY(2px) !important;
		}

		.spoilerContent-32CqO-.spoilerContainer-1Dl06W {
			background-color: rgba(255, 255, 255, 0);
		}

	`;
	document.head.appendChild(style);
	return style;
	}

	function runMutation() {
		convertMediaToCDN();
		replaceURLs();
		checkForGridLayout();
		enhanceAvatarQuality();
		enhanceIconQuality();
		setTimeout(adjustMaxWidthBasedOnCurrentWidth, 3000);
		localObserver.observe(document, config);

		let images = document.querySelectorAll('.imageContainer-10XenG .lazyImg-ewiNCh.processed-image.processed-single-layout');
		images.forEach((image) => {
		image.addEventListener('load', function () {
			const classElement = image.closest('.imageWrapper-oMkQl4.imageZoom-3yLCXY.clickable-LksVCf.lazyImgContainer-3k3gRy.processed-single-layout');
			if (classElement && image.naturalWidth > image.naturalHeight) {
			classElement.classList.add('auto-width');
		}
		});
	});
	}

	runMutation();

	if (!this.UncompressedImagesCSSStyle) {
		this.UncompressedImagesCSSStyle = createUncompressedImagesCSSStyle();
	}
	
	this.mutationObserver = localObserver;
	
	/** 
	Main code ends here, don't forget. 
	That "}" is attached to the "start () {" function.
	*/

} stop() {
	if (this.mutationObserver) {
		this.mutationObserver.disconnect();
		this.mutationObserver = null; 

		const autoWidthElements = document.querySelectorAll('.auto-width');
		autoWidthElements.forEach((element) => {
			element.classList.remove('auto-width');
		});

		const maxWidthAdjustedImages = document.querySelectorAll('.max-width-adjusted');
		maxWidthAdjustedImages.forEach((image) => {
			image.classList.remove('max-width-adjusted');
		}); 

		const processedAvatars = document.querySelectorAll('.processed-avatar');
		processedAvatars.forEach((image) => {
			image.src = image.src.replace('?quality=lossless', '');
			image.classList.remove('processed-avatar');
		});
		
		const processedIcons = document.querySelectorAll('.processed-icon');
		processedIcons.forEach((image) => {
			image.src = image.src.replace('?quality=lossless', '');
			image.classList.remove('processed-icon');
		});

		const processedImages = document.querySelectorAll('.processed-image');
		processedImages.forEach((image) => {
			image.src = image.src.replace(
				'https://cdn.discordapp.com/attachments',
				'https://media.discordapp.net/attachments'
			);
				image.classList.remove('processed-image');
			});

			const hiddenImages = document.querySelectorAll(
				'.messageListItem-ZZ7v6g .imageDetails-1t6Zms'
			);
			
			hiddenImages.forEach((image) => {
				image.style.removeProperty('display');
				image.style.removeProperty('transform');
				image.style.lineHeight = '16px';
				image.style.display = '';
			});

			const singleLayoutImages = document.querySelectorAll('.processed-single-layout');
				singleLayoutImages.forEach((image) => {
				image.classList.remove('processed-single-layout');
			});

			const gridImages = document.querySelectorAll('.processed-grid-layout');
				gridImages.forEach((image) => {
				image.classList.remove('processed-grid-layout');
			});

			if (this.UncompressedImagesCSSStyle) {
				this.UncompressedImagesCSSStyle.remove();
				this.UncompressedImagesCSSStyle = null;
			}
		
			if (this.resizeListener) {
				window.removeEventListener('resize', this.resizeListener);
				this.resizeListener = null;
			}  
			
			const imageDetailsElements = document.querySelectorAll('.imageDetails-1t6Zms');
			imageDetailsElements.forEach((element) => {
				const commonParent = element.closest('.imageContent-3Av-9c.embedWrapper-1MtIDg.attachmentContentContainer-3WAhvQ.attachmentContentItem-UKeiCx');
				const targetParent = commonParent.querySelector('.imageContainer-10XenG div');
				if (targetParent) {
					targetParent.appendChild(element);
				}
			});
			
			if (this.animationFrame) {
			cancelAnimationFrame(this.animationFrame);
			this.animationFrame = null;
			}
			
			if (this.resizeListener) {
			window.removeEventListener('resize', debounce(centerImageBecauseRegularCSSWillNot, 100));
			this.resizeListener = null;
			}
			
		}
}
};

/**
* Version 3.15 of Uncompressed Images
* Copyright (Boost Software License 1.0) 2023-2023 Knew
* Link to plugin: https://github.com/Knewest/uncompressed-discord-images
* Support server: https://discord.gg/NqqqzajfK4
*/
