
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/pci.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>

#define PCIX_NAME 		"pcix"
#define PCIX_BAR 		0
#define PCIX_VENDOR_ID	0x1234
#define PCIX_DEVICE_ID	0x11e8

static struct pci_device_id pci_ids[] = {
	{ PCI_DEVICE(PCIX_VENDOR_ID, PCIX_DEVICE_ID), },
	{ 0, }
};
MODULE_DEVICE_TABLE(pci, pci_ids);

static ssize_t pcix_read(struct file *file, char __user *buf,
						size_t count, loff_t *ppos)
{
	return 0;
	//return simple_read_from_buffer(buf, count, ppos, buffer, BUF_SIZE);
}

static ssize_t pcix_write(struct file *file, const char __user *udata,
						size_t count, loff_t *ppos)
{
	return -1;
	//return simple_write_to_buffer(buffer, BUF_SIZE, ppos, udata, count);
}

const struct file_operations misc_fops = {
	.owner		= THIS_MODULE,
	.read		= pcix_read,
	.write		= pcix_write,
};

static struct miscdevice misc_dev = {
	MISC_DYNAMIC_MINOR,
	PCIX_NAME,
	&misc_fops
};

static int pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
{
	pr_info("pci_probe\n");

	if (pci_enable_device(dev)) {
		dev_err(&(dev->dev), "pci_enable_device\n");
		goto error;
	}

	if (pci_request_region(dev, PCIX_BAR, "myregion0")) {
		dev_err(&(dev->dev), "pci_request_region\n");
		goto error;
	}


	if (misc_register(&misc_dev)){
		dev_err(&(dev->dev), "misc_register\n");
		goto error;
	}

	return 0;
error:
	//TODO: check error code rules
	return 1;
}

static void pci_remove(struct pci_dev *dev)
{
	pr_info("pci_remove\n");
	pci_release_region(dev, PCIX_BAR);
}

static struct pci_driver pci_driver = {
	.name     = PCIX_NAME,
	.id_table = pci_ids,
	.probe    = pci_probe,
	.remove   = pci_remove,
};

static int  pcix_init(void)
{
	//TODO: check error code rules
	pr_info("pci_register_driver\n");
	return pci_register_driver(&pci_driver);
}

static void pcix_exit(void)
{
	pr_info("pci_unregister_driver\n");
	pci_unregister_driver(&pci_driver);
}

module_init(pcix_init)
module_exit(pcix_exit)
MODULE_LICENSE("GPL");
