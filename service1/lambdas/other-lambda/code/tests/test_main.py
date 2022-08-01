from unittest import TestCase

from main import handler


class TestOtherLambda(TestCase):
    def test_it_works(self):
        handler(None, None)
        self.assertTrue(True)
