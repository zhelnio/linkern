
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/miscdevice.h>
#include <linux/uaccess.h>
#include <linux/string.h>
#include <linux/fs.h>

#define BUF_SIZE		100
#define BUF_DEFAULT		"Pcix Hello!\n"

char buffer[BUF_SIZE];

static ssize_t misc_read(struct file *file, char __user *buf,
						size_t count, loff_t *ppos)
{
	return simple_read_from_buffer(buf, count, ppos, buffer, BUF_SIZE);
}

static ssize_t misc_write(struct file *file, const char __user *udata,
						size_t count, loff_t *ppos)
{
	return simple_write_to_buffer(buffer, BUF_SIZE, ppos, udata, count);
}

const struct file_operations misc_fops = {
	.owner		= THIS_MODULE,
	.read		= misc_read,
	.write		= misc_write,
};

static struct miscdevice misc_dev = {
	MISC_DYNAMIC_MINOR,
	"misc",
	&misc_fops
};

int  __init misc_init(void)
{
	int ret = 0;
	
	pr_info("misc init\n");

	strncpy(buffer, BUF_DEFAULT, BUF_SIZE);

	ret = misc_register(&misc_dev);
	if (ret != 0)
		goto out;

out:
	return ret;
}

void __exit misc_exit(void)
{
	pr_info("misc exit\n");
}

module_init(misc_init)
module_exit(misc_exit)
MODULE_LICENSE("GPL");
